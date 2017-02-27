#import "ClusteringExample.h"
@import Mapbox;

NSString *const MBXExampleClustering = @"ClusteringExample";

@interface ClusteringExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIImage *sprite;
@property (nonatomic) UILabel *popup;

@end

@implementation ClusteringExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    self.sprite = [UIImage imageNamed:@"sprite"];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ports" ofType:@"geojson"]];

    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"clusteredPorts"
                                                                    URL:url
                                                                options:@{ MGLShapeSourceOptionClustered: @(YES),
                                                                           MGLShapeSourceOptionClusterRadius: @(self.sprite.size.width) }];
    [style addSource:source];

    // Use a template image so that we can tint it with the `iconColor` runtime styling property.
    [style setImage:[self.sprite imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forName:@"sprite"];

    // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
    MGLSymbolStyleLayer *ports = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"ports" source:source];
    ports.iconImageName = [MGLStyleValue valueWithRawValue:@"sprite"];
    ports.iconColor = [MGLStyleValue valueWithRawValue:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9]];
    ports.predicate = [NSPredicate predicateWithFormat:@"%K != YES", @"cluster"];
    [style addLayer:ports];

    // Color clustered features based on clustered point counts.
    NSDictionary *stops = @{ @20:  [MGLStyleValue valueWithRawValue:[UIColor lightGrayColor]],
                             @50:  [MGLStyleValue valueWithRawValue:[UIColor orangeColor]],
                             @100: [MGLStyleValue valueWithRawValue:[UIColor redColor]],
                             @300: [MGLStyleValue valueWithRawValue:[UIColor purpleColor]] };

    // Show clustered features as circles. The `point_count` attribute is built into clustering-enabled source features.
    MGLCircleStyleLayer *circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clusteredPorts" source:source];
    circleLayer.circleRadius = [MGLStyleValue valueWithRawValue:@(self.sprite.size.width / 2)];
    circleLayer.circleOpacity = [MGLStyleValue valueWithRawValue:@0.75];
    circleLayer.circleStrokeColor = [MGLStyleValue valueWithRawValue:[[UIColor whiteColor] colorWithAlphaComponent:0.75]];
    circleLayer.circleStrokeWidth = [MGLStyleValue valueWithRawValue:@2];
    circleLayer.circleColor = [MGLSourceStyleFunction functionWithInterpolationMode:MGLInterpolationModeInterval
                                                                              stops:stops
                                                                      attributeName:@"point_count"
                                                                            options:nil];
    circleLayer.predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"cluster"];
    [style addLayer:circleLayer];

    // Label cluster circles with a layer of text indicating feature count. Per text token convention, wrap the attibute in {}.
    MGLSymbolStyleLayer *clusteredLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"clusteredPortsNumbers" source:source];
    clusteredLayer.textColor = [MGLStyleValue valueWithRawValue:[UIColor whiteColor]];
    clusteredLayer.textFontSize = [MGLStyleValue valueWithRawValue:@(self.sprite.size.width / 2)];
    clusteredLayer.iconAllowsOverlap = [MGLStyleValue valueWithRawValue:@(YES)];
    clusteredLayer.text = [MGLStyleValue valueWithRawValue:@"{point_count}"];
    clusteredLayer.predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"cluster"];
    [style addLayer:clusteredLayer];

    // Add a long-press gesture for zooming in to clusters or showing popups on individual features.
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];
}

- (void)mapViewRegionIsChanging:(MGLMapView *)mapView {
    self.popup.alpha = 0;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPress locationInView:longPress.view];
        CGFloat width = self.sprite.size.width;
        CGRect rect = CGRectMake(point.x - width / 2, point.y - width / 2, width, width);

        NSArray *clusters = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObject:@"clusteredPorts"]];
        NSArray *ports    = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObject:@"ports"]];

        if (clusters.count) {
            [UIView animateWithDuration:0.25 animations:^{
                self.popup.alpha = 0;
            }];
            MGLPointFeature *cluster = (MGLPointFeature *)clusters.firstObject;
            [self.mapView setCenterCoordinate:cluster.coordinate zoomLevel:(self.mapView.zoomLevel + 1) animated:YES];
        } else if (ports.count) {
            MGLPointFeature *port = ((MGLPointFeature *)ports.firstObject);

            if (!self.popup) {
                self.popup = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
                self.popup.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
                self.popup.layer.cornerRadius = 5;
                self.popup.layer.masksToBounds = YES;
                self.popup.textAlignment = NSTextAlignmentCenter;
                self.popup.lineBreakMode = NSLineBreakByTruncatingTail;
                self.popup.font = [UIFont systemFontOfSize:14];
                self.popup.textColor = [UIColor blackColor];
                self.popup.alpha = 0;
                [self.view addSubview:self.popup];
            }

            self.popup.text = [NSString stringWithFormat:@" %@  ", [port attributeForKey:@"name"]];
            point = [self.mapView convertCoordinate:port.coordinate toPointToView:self.mapView];
            self.popup.center = CGPointMake(point.x, point.y - 50);

            if (self.popup.alpha < 1) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.popup.alpha = 1;
                }];
            }
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.popup.alpha = 0;
            }];
        }
    }
}

@end
