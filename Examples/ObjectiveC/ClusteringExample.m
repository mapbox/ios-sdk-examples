#import "ClusteringExample.h"
@import Mapbox;

NSString *const MBXExampleClustering = @"ClusteringExample";

@interface ClusteringExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UILabel *popup;

@end

@implementation ClusteringExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];

    self.mapView.delegate = self;

//    self.mapView.userInteractionEnabled = NO;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ports" ofType:@"geojson"]];

    MGLShapeSource *clusteredSource = [[MGLShapeSource alloc] initWithIdentifier:@"clusteredPorts" URL:url options:@{ MGLShapeSourceOptionClustered: @(YES), MGLShapeSourceOptionClusterRadius: @32 }];
    [style addSource:clusteredSource];

//    MGLShapeSource *normalSource = [[MGLShapeSource alloc] initWithIdentifier:@"normalPorts" URL:url options:@{ MGLShapeSourceOptionClustered: @(NO) }];
//    [style addSource:normalSource];

    [style setImage:[[UIImage imageNamed:@"sprite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forName:@"sprite"];

    MGLSymbolStyleLayer *ships = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"ships" source:clusteredSource];
    ships.iconImageName = [MGLStyleValue valueWithRawValue:@"sprite"];
    ships.iconColor = [MGLStyleValue valueWithRawValue:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9]];
    ships.predicate = [NSPredicate predicateWithFormat:@"%K != YES", @"cluster"];
    [style addLayer:ships];
//    [style insertLayer:ships belowLayer:[style layerWithIdentifier:@"waterway-label"]];

    MGLCircleStyleLayer *circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clusteredPorts" source:clusteredSource];
    circleLayer.circleRadius = [MGLStyleValue valueWithRawValue:@16];
    circleLayer.circleOpacity = [MGLStyleValue valueWithRawValue:@0.75];
    circleLayer.circleStrokeColor = [MGLStyleValue valueWithRawValue:[[UIColor whiteColor] colorWithAlphaComponent:0.75]];
    circleLayer.circleStrokeWidth = [MGLStyleValue valueWithRawValue:@2];
    circleLayer.circleColor = [MGLSourceStyleFunction functionWithInterpolationMode:MGLInterpolationModeInterval
                                                                              stops:@{ @20:  [MGLStyleValue valueWithRawValue:[UIColor lightGrayColor]],
                                                                                       @50:  [MGLStyleValue valueWithRawValue:[UIColor orangeColor]],
                                                                                       @100: [MGLStyleValue valueWithRawValue:[UIColor redColor]],
                                                                                       @300: [MGLStyleValue valueWithRawValue:[UIColor purpleColor]] }
                                                                      attributeName:@"point_count"
                                                                            options:nil];
    circleLayer.predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"cluster"];
    [style addLayer:circleLayer];
//    [style insertLayer:circleLayer belowLayer:[style layerWithIdentifier:@"waterway-label"]];

    MGLSymbolStyleLayer *clusteredLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"clusteredPortsNumbers" source:clusteredSource];
    clusteredLayer.textColor = [MGLStyleValue valueWithRawValue:[UIColor whiteColor]];
    clusteredLayer.textFontSize = [MGLStyleValue valueWithRawValue:@16];
    clusteredLayer.iconAllowsOverlap = [MGLStyleValue valueWithRawValue:@(YES)];
    clusteredLayer.text = [MGLStyleValue valueWithRawValue:@"{point_count}"];
    clusteredLayer.predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"cluster"];
    [style addLayer:clusteredLayer];
//    [style insertLayer:clusteredLayer belowLayer:[style layerWithIdentifier:@"waterway-label"]];

//    MGLSymbolStyleLayer *normalLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"normalPorts" source:normalSource];
//    normalLayer.iconImageName = [MGLStyleValue valueWithRawValue:@"ship"];
//    normalLayer.iconColor = [MGLStyleValue valueWithRawValue:[[UIColor darkGrayColor] colorWithAlphaComponent:0.75]];
//    normalLayer.iconAllowsOverlap = [MGLStyleValue valueWithRawValue:@(YES)];
//    normalLayer.iconOpacity = [MGLStyleValue valueWithRawValue:@0];
////    normalLayer.visible = NO;
//    [style addLayer:normalLayer];

//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
//    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
//    twoFingerTap.numberOfTouchesRequired = 2;
//    [self.view addGestureRecognizer:twoFingerTap];

    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while(YES) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                double rotation = ((NSNumber *)((MGLStyleConstantValue *)ships.iconRotation).rawValue).doubleValue;
                rotation += 1;
                ships.iconRotation = [MGLStyleValue valueWithRawValue:@(rotation)];
            });
            usleep(1000);
        }
    });
}

- (void)mapViewRegionIsChanging:(MGLMapView *)mapView {
    self.popup.alpha = 0;
}

//- (void)handleTap:(UITapGestureRecognizer *)tap {
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
//    if (tap.state == UIGestureRecognizerStateEnded) {
    if (longPress.state == UIGestureRecognizerStateBegan) {
//        CGPoint point = [tap locationInView:tap.view];
        CGPoint point = [longPress locationInView:longPress.view];
        CGRect rect = CGRectMake(point.x - 16, point.y - 16, 32, 32);
//
//        NSArray *clusters = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObject:@"clusteredPorts"]];
//
//        if (clusters.count) {
//            point = [self.mapView convertCoordinate:((MGLPointFeature *)clusters.firstObject).coordinate toPointToView:self.mapView];
//            rect = CGRectMake(point.x - 20, point.y - 20, 40, 40);
//
//            NSArray *ports = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObject:@"normalPorts"]];
//
//            NSLog(@"%lu (%lu)", clusters.count, ports.count);
//        }

        NSArray *ports = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObjects:/*@"normalPorts",*/ @"clusteredPorts", nil]];
        NSArray *ships = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObject:@"ships"]];

        if (ports.count) {
            [UIView animateWithDuration:0.25 animations:^{
                self.popup.alpha = 0;
            }];
            MGLPointFeature *port = (MGLPointFeature *)ports.firstObject;
            [self.mapView setCenterCoordinate:port.coordinate zoomLevel:(self.mapView.zoomLevel + 1) animated:YES];
//            NSLog(@"%@", ports);
//        } else {
//            MGLSymbolStyleLayer *normalLayer = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"normalPorts"];
//            [self.mapView.style layerWithIdentifier:@"clusteredPorts"].visible = normalLayer.isVisible;
//            [self.mapView.style layerWithIdentifier:@"clusteredPortsNumbers"].visible = normalLayer.isVisible;
//            normalLayer.visible = !normalLayer.isVisible;
        } else if (ships.count) {
            MGLPointFeature *ship = ((MGLPointFeature *)ships.firstObject);

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

            self.popup.text = [NSString stringWithFormat:@" %@  ", [ship attributeForKey:@"name"]];
            point = [self.mapView convertCoordinate:ship.coordinate toPointToView:self.mapView];
//            if (point.y < 50) point.y += 100;
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

- (void)handleTwoFingerTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.25 animations:^{
            self.popup.alpha = 0;
        }];
        [self.mapView setCenterCoordinate:[self.mapView convertPoint:[tap locationInView:tap.view] toCoordinateFromView:self.mapView]
                                zoomLevel:(self.mapView.zoomLevel - 1)
                                 animated:YES];
    }
}

@end
