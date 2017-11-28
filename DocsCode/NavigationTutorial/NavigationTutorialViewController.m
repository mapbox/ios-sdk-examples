// #-code-snippet: navigation dependencies-objc
#import "NavigationTutorialViewController.h"

@import Mapbox;
@import MapboxCoreNavigation;
@import MapboxNavigation;
@import MapboxDirections;
// #-end-code-snippet: navigation dependencies-objc

@interface NavigationTutorialViewController () <MGLMapViewDelegate>

@property (nonatomic) MBNavigationMapView *mapView;
// #-code-snippet: navigation directions-route-objc
@property (nonatomic) MBRoute *directionsRoute;
// #-end-code-snippet: navigation directions-route-objc


@end

@implementation NavigationTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // #-code-snippet: navigation init-map-objc
    self.mapView = [[MBNavigationMapView alloc] initWithFrame:self.view.bounds];

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.265, -97.741)
                            zoomLevel:11 animated:NO];
    [self.view addSubview:self.mapView];
    // Set the map view's delegate
    self.mapView.delegate = self;
    // #-end-code-snippet: navigation init-map-objc
    
    // #-code-snippet: navigation user-location-objc
    // Allow the map view to display the user's location
    self.mapView.showsUserLocation = YES;
    // #-end-code-snippet: navigation user-location-objc
    
    // #-code-snippet: navigation gesture-recognizer-objc
    // Add a gesture recognizer to the map view
    UITapGestureRecognizer *setDestination = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.mapView addGestureRecognizer:setDestination];
    // #-end-code-snippet: navigation gesture-recognizer-objc
}

// #-code-snippet: navigation allow-callouts-objc
// Implement the delegate method that allows annotations to show callouts when tapped
-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return true;
}
// #-end-code-snippet: navigation allow-callouts-objc

// #-code-snippet: navigation long-press-objc
-(void)didLongPress:(UITapGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    // Converts point where user did a long press to map coordinates
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    // Create a basic point annotation and add it to the map
    MGLPointAnnotation *annotation = [MGLPointAnnotation alloc];
    annotation.coordinate = coordinate;
    annotation.title = @"Start navigtation";
    [self.mapView addAnnotation:annotation];
    
    // Calcuate the route from the user's location to the set destination
    [self calculateRoutefromOrigin:self.mapView.userLocation.coordinate
                     toDestination:annotation.coordinate
                        completion:^(MBRoute * _Nullable route, NSError * _Nullable error) {
                            if (error != nil) {
                                NSLog(@"Error calculating route");
                            }
                        }];
}
// #-end-code-snippet: navigation long-press-objc

// #-code-snippet: navigation calculate-route-objc
-(void)calculateRoutefromOrigin:(CLLocationCoordinate2D)origin
                 toDestination :(CLLocationCoordinate2D)destination
                     completion:(void(^)(MBRoute *_Nullable route, NSError *_Nullable error))completion {
    
    // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
    MBWaypoint *originWaypoint = [[MBWaypoint alloc] initWithCoordinate:origin coordinateAccuracy:-1 name:@"Start"];
    
    MBWaypoint *destinationWaypoint = [[MBWaypoint alloc] initWithCoordinate:destination coordinateAccuracy:-1 name:@"Finish"];
    
    // Specify that the route is intented for automobiles avoiding traffic
    MBNavigationRouteOptions *options = [[MBNavigationRouteOptions alloc] initWithWaypoints:@[originWaypoint, destinationWaypoint] profileIdentifier:MBDirectionsProfileIdentifierAutomobileAvoidingTraffic];
    
    // Generate the route object and draw it on the map
    NSURLSessionDataTask *task = [[MBDirections sharedDirections] calculateDirectionsWithOptions:options completionHandler:^(
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
-(void)drawRoute:(CLLocationCoordinate2D *)route {
    if (self.directionsRoute.coordinateCount == 0) {
        return;
    }
    
    // Convert the route’s coordinates into a polyline.
    MGLPolylineFeature *polyline = [MGLPolylineFeature polylineWithCoordinates:route count:self.directionsRoute.coordinateCount];
    
    if ([self.mapView.style sourceWithIdentifier:@"route-source"]) {
        // If there's already a route line on the map, reset its shape to the new route
        MGLShapeSource *source = [self.mapView.style sourceWithIdentifier:@"route-source"];
        source.shape = polyline;
    } else {
        MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"route-source" shape:polyline options:nil];
        MGLLineStyleLayer *lineStyle = [[MGLLineStyleLayer alloc] initWithIdentifier:@"route-style" source:source];
        
        // Customize the route line color and width
        lineStyle.lineColor = [MGLStyleValue valueWithRawValue:[UIColor blueColor]];
        lineStyle.lineWidth = [MGLStyleValue valueWithRawValue:@"3"];
        
        // Add the source and style layer of the route line to the map
        [self.mapView.style addSource:source];
        [self.mapView.style addLayer:lineStyle];
    }
    
}
// #-end-code-snippet: navigation draw-route-objc

// #-code-snippet: navigation tap-callout-objc
-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    MBNavigationViewController *navigationViewController = [[MBNavigationViewController alloc] initWithRoute:_directionsRoute directions:[MBDirections sharedDirections] style:nil locationManager:nil];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}
// #-end-code-snippet: navigation tap-callout-objc

@end
