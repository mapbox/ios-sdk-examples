// #-code-snippet: navigation dependencies-objc
#import "NavigationTutorialViewController.h"

@import Mapbox;
@import MapboxCoreNavigation;
@import MapboxNavigation;
@import MapboxDirections;
// #-end-code-snippet: navigation dependencies-objc

@interface NavigationTutorialViewController () <MGLMapViewDelegate>

// #-code-snippet: navigation vc-variables-objc
@property (nonatomic) MBNavigationMapView *mapView;
@property (nonatomic) MBRoute *directionsRoute;
// #-end-code-snippet: navigation vc-variables-objc

@end

@implementation NavigationTutorialViewController

// #-code-snippet: navigation view-did-load-objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MBNavigationMapView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.mapView];
    // Set the map view's delegate
    self.mapView.delegate = self;
    
    // Allow the map view to display the user's location
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES];
    
    // Add a gesture recognizer to the map view
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.mapView addGestureRecognizer:longPress];
}
// #-end-code-snippet: navigation view-did-load-objc

// #-code-snippet: navigation long-press-objc
- (void)didLongPress:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    // Converts point where user did a long press to map coordinates
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    // Create a basic point annotation and add it to the map
    MGLPointAnnotation *annotation = [MGLPointAnnotation alloc];
    annotation.coordinate = coordinate;
    annotation.title = @"Start navigation";
    [self.mapView addAnnotation:annotation];
    
    // Calculate the route from the user's location to the set destination
    [self calculateRoutefromOrigin:self.mapView.userLocation.coordinate
                     toDestination:annotation.coordinate
                        completion:^(MBRoute * _Nullable route, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error calculating route: %@", error);
        }
    }];
}
// #-end-code-snippet: navigation long-press-objc

// #-code-snippet: navigation calculate-route-objc
- (void)calculateRoutefromOrigin:(CLLocationCoordinate2D)origin
                   toDestination:(CLLocationCoordinate2D)destination
                      completion:(void(^)(MBRoute *_Nullable route, NSError *_Nullable error))completion {
    
    // Coordinate accuracy is how close the route must come to the waypoint in order to be considered viable. It is measured in meters. A negative value indicates that the route is viable regardless of how far the route is from the waypoint.
    MBWaypoint *originWaypoint = [[MBWaypoint alloc] initWithCoordinate:origin coordinateAccuracy:-1 name:@"Start"];
    
    MBWaypoint *destinationWaypoint = [[MBWaypoint alloc] initWithCoordinate:destination coordinateAccuracy:-1 name:@"Finish"];
    
    // Specify that the route is intended for automobiles avoiding traffic
    MBNavigationRouteOptions *options = [[MBNavigationRouteOptions alloc] initWithWaypoints:@[originWaypoint, destinationWaypoint] profileIdentifier:MBDirectionsProfileIdentifierAutomobileAvoidingTraffic];
    
    // Generate the route object and draw it on the map
    (void)[[MBDirections sharedDirections] calculateDirectionsWithOptions:options completionHandler:^(
        NSArray<MBWaypoint *> *waypoints,
        NSArray<MBRoute *> *routes,
        NSError *error) {
        
        if (!routes.firstObject) {
            return;
        }
        
        MBRoute *route = routes.firstObject;
        self.directionsRoute = route;
        CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
        [route getCoordinates:routeCoordinates];
        // Draw the route on the map after creating it
        [self drawRoute:routeCoordinates];
    }];
}
// #-end-code-snippet: navigation calculate-route-objc

// #-code-snippet: navigation draw-route-objc
- (void)drawRoute:(CLLocationCoordinate2D *)route {
    if (self.directionsRoute.coordinateCount == 0) {
        return;
    }
    
    // Convert the route’s coordinates into a polyline.
    MGLPolylineFeature *polyline = [MGLPolylineFeature polylineWithCoordinates:route count:self.directionsRoute.coordinateCount];
    
    if ([self.mapView.style sourceWithIdentifier:@"route-source"]) {
        // If there's already a route line on the map, reset its shape to the new route
        MGLShapeSource *source = (MGLShapeSource *)[self.mapView.style sourceWithIdentifier:@"route-source"];
        source.shape = polyline;
    } else {
        MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"route-source" shape:polyline options:nil];
        MGLLineStyleLayer *lineStyle = [[MGLLineStyleLayer alloc] initWithIdentifier:@"route-style" source:source];
        
        // Customize the route line color and width
        lineStyle.lineColor = [NSExpression expressionForConstantValue:[UIColor blueColor]];
        lineStyle.lineWidth = [NSExpression expressionForConstantValue:@3];
        
        // Add the source and style layer of the route line to the map
        [self.mapView.style addSource:source];
        [self.mapView.style addLayer:lineStyle];
    }
}
// #-end-code-snippet: navigation draw-route-objc

// #-code-snippet: navigation callout-functions-objc
// Implement the delegate method that allows annotations to show callouts when tapped
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return true;
}

// Present the navigation view controller when the callout is selected
- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    MBNavigationViewController *navigationViewController = [[MBNavigationViewController alloc] initWithRoute:self.directionsRoute options:nil];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}
// #-end-code-snippet: navigation callout-functions-objc

@end
