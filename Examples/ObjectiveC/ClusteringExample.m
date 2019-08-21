#import "ClusteringExample.h"
@import Mapbox;

NSString *const MBXExampleClustering = @"ClusteringExample";

@interface ClusteringExample () <MGLMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIView *popup;

@end

@implementation ClusteringExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.tintColor = [UIColor darkGrayColor];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    // Add a double tap gesture recognizer. This gesture is used for double
    // tapping on clusters and then zooming in so the cluster expands to its
    // children.
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapCluster:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    
    // It's important that this new double tap fails before the map view's
    // built-in gesture can be recognized. This is to prevent the map's gesture from
    // overriding this new gesture (and then not detecting a cluster that had been
    // tapped on).
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]] &&
            ((UITapGestureRecognizer*)recognizer).numberOfTapsRequired == 2) {
            [recognizer requireGestureRecognizerToFail:doubleTap];
        }
    }
    [self.mapView addGestureRecognizer:doubleTap];
    
    // Add a single tap gesture recognizer. This gesture requires the built-in
    // MGLMapView tap gestures (such as those for zoom and annotation selection)
    // to fail (this order differs from the double tap above).
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [singleTap requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:singleTap];

    self.icon = [UIImage imageNamed:@"port"];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ports" ofType:@"geojson"]];

    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"clusteredPorts" URL:url options:@{
        MGLShapeSourceOptionClustered: @(YES),
        MGLShapeSourceOptionClusterRadius: @(self.icon.size.width)
    }];
    [style addSource:source];

    // Use a template image so that we can tint it with the `iconColor` runtime styling property.
    [style setImage:[self.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forName:@"icon"];

    // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled
    // source features.
    MGLSymbolStyleLayer *ports = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"ports" source:source];
    ports.iconImageName = [NSExpression expressionForConstantValue:@"icon"];
    ports.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
    ports.iconColor = [NSExpression expressionForConstantValue:[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f]];
    ports.predicate = [NSPredicate predicateWithFormat:@"cluster != YES"];
    [style addLayer:ports];

    // Color clustered features based on clustered point counts.
    NSDictionary *stops = @{ @20:  [UIColor lightGrayColor],
                             @50:  [UIColor orangeColor],
                             @100: [UIColor redColor],
                             @200: [UIColor purpleColor] };
    
    // Show clustered features as circles. The `point_count` attribute is built into
    // clustering-enabled source features.
    MGLCircleStyleLayer *circlesLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clusteredPorts" source:source];
    circlesLayer.circleRadius = [NSExpression expressionForConstantValue:@(self.icon.size.width / 2)];
    circlesLayer.circleOpacity = [NSExpression expressionForConstantValue:@0.75];
    circlesLayer.circleStrokeColor = [NSExpression expressionForConstantValue:[[UIColor whiteColor] colorWithAlphaComponent:0.75]];
    circlesLayer.circleStrokeWidth = [NSExpression expressionForConstantValue:@2];
    circlesLayer.circleColor = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(point_count, %@, %@)",
                                [UIColor lightGrayColor], stops];
    circlesLayer.predicate = [NSPredicate predicateWithFormat:@"cluster == YES"];
    [style addLayer:circlesLayer];

    // Label cluster circles with a layer of text indicating feature count. The value for
    // `point_count` is an integer. In order to use that value for the
    // `MGLSymbolStyleLayer.text` property, cast it as a string.
    MGLSymbolStyleLayer *numbersLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"clusteredPortsNumbers" source:source];
    numbersLayer.textColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    numbersLayer.textFontSize = [NSExpression expressionForConstantValue:@(self.icon.size.width / 2)];
    numbersLayer.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
    numbersLayer.text = [NSExpression expressionWithFormat:@"CAST(point_count, 'NSString')"];
    numbersLayer.predicate = [NSPredicate predicateWithFormat:@"cluster == YES"];
    [style addLayer:numbersLayer];
}

- (void)mapViewRegionIsChanging:(MGLMapView *)mapView {
    [self showPopup:NO animated:NO];
}

- (MGLPointFeatureCluster *)firstClusterWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat width = self.icon.size.width;
    CGRect rect = CGRectMake(point.x - width / 2, point.y - width / 2, width, width);

    // This example shows how to check if a feature is a cluster by
    // checking for that the feature is a `MGLPointFeatureCluster`. Alternatively, you could
    // also check for conformance with `MGLCluster` instead.
    NSArray<id<MGLFeature>> *features = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObjects:@"clusteredPorts", @"ports", nil]];
    
    NSPredicate *clusterPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[MGLPointFeatureCluster class]];
    }];

    NSArray *clusters = [features filteredArrayUsingPredicate:clusterPredicate];

    // Pick the first cluster, ideally selecting the one nearest nearest one to
    // the touch point.
    return (MGLPointFeatureCluster *)clusters.firstObject;
}

- (IBAction)handleDoubleTapCluster:(UITapGestureRecognizer *)sender {
    
    MGLSource *source = [self.mapView.style sourceWithIdentifier:@"clusteredPorts"];
    
    if (![source isKindOfClass:[MGLShapeSource class]]) {
        return;
    }

    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }

    [self showPopup:NO animated:NO];
    
    MGLPointFeatureCluster *cluster = [self firstClusterWithGestureRecognizer:sender];
    
    if (!cluster) {
        return;
    }

    double zoom = [(MGLShapeSource *)source zoomLevelForExpandingCluster:cluster];

    if (zoom > 0.0) {
        [self.mapView setCenterCoordinate:cluster.coordinate
                                zoomLevel:zoom
                                 animated:YES];
    }
}


- (IBAction)handleMapTap:(UITapGestureRecognizer *)tap {
    
    MGLSource *source = [self.mapView.style sourceWithIdentifier:@"clusteredPorts"];
    
    if (![source isKindOfClass:[MGLShapeSource class]]) {
        return;
    }
    
    if (tap.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self showPopup:NO animated:NO];
    
    CGPoint point = [tap locationInView:tap.view];
    CGFloat width = self.icon.size.width;
    CGRect rect = CGRectMake(point.x - width / 2, point.y - width / 2, width, width);

    NSArray<id<MGLFeature>> *features = [self.mapView visibleFeaturesInRect:rect inStyleLayersWithIdentifiers:[NSSet setWithObjects:@"clusteredPorts", @"ports", nil]];
    
    // Pick the first feature (which may be a port or a cluster), ideally selecting
    // the one nearest nearest one to the touch point.
    id<MGLFeature> feature = features.firstObject;
    
    if (!feature) {
        return;
    }
    
    NSString *description = @"No port name";
    UIColor *color = UIColor.redColor;
    
    if ([feature isKindOfClass:[MGLPointFeatureCluster class]]) {
        // Tapped on a cluster.
        MGLPointFeatureCluster *cluster = (MGLPointFeatureCluster *)feature;
        
        NSArray *children = [(MGLShapeSource*)source childrenOfCluster:cluster];
        description = [NSString stringWithFormat:@"Cluster #%zd\n%zd children",
                       cluster.clusterIdentifier,
                       children.count];
        color = UIColor.blueColor;
    } else {
        // Tapped on a port.
        id name = [feature attributeForKey:@"name"];
        if ([name isKindOfClass:[NSString class]]) {
            description = (NSString *)name;
            color = UIColor.blackColor;
        }
    }
    
    self.popup = [self popupAtCoordinate:feature.coordinate
                         withDescription:description
                               textColor:color];
    
    [self showPopup:YES animated:YES];
}

- (UIView *)popupAtCoordinate:(CLLocationCoordinate2D)coordinate withDescription:(NSString *)description textColor:(UIColor *)textColor {
    UILabel *popup = [[UILabel alloc] init];
    
    popup.backgroundColor     = [[UIColor whiteColor] colorWithAlphaComponent:0.9f];
    popup.layer.cornerRadius  = 4;
    popup.layer.masksToBounds = YES;
    popup.textAlignment       = NSTextAlignmentCenter;
    popup.lineBreakMode       = NSLineBreakByTruncatingTail;
    popup.numberOfLines       = 0;
    popup.font                = [UIFont systemFontOfSize:16];
    popup.textColor           = textColor;
    popup.alpha               = 0;
    popup.text                = description;

    [popup sizeToFit];
    
    // Expand the popup.
    popup.bounds = CGRectInset(popup.bounds, -10, -10);
    CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    popup.center = CGPointMake(point.x, point.y - 50);

    return popup;
}

- (void)showPopup:(BOOL)shouldShow animated:(BOOL)animated {
    if (!self.popup) {
        return;
    }
    
    UIView *popup = self.popup;
    
    if (shouldShow) {
        [self.view addSubview:popup];
    }
    
    CGFloat alpha = (shouldShow ? 1 : 0);
    
    dispatch_block_t animation = ^{
        popup.alpha = alpha;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (!shouldShow) {
            [popup removeFromSuperview];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:animation
                         completion:completion];
    } else {
        animation();
        completion(YES);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // This will only get called for the custom double tap gesture,
    // that should always be recognized simultaneously.
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // This will only get called for the custom double tap gesture.
    return [self firstClusterWithGestureRecognizer:gestureRecognizer] != nil;
}
    
@end
