// #-code-snippet: navigation full-tutorial-objc
// #-code-snippet: navigation dependencies-objc
#import "NavigationTutorialViewController"

@import Mapbox;
@import MapboxCoreNavigation;
@import MapboxNavigation;
@import MapboxDirections;
// #-end-code-snippet: navigation dependencies-objc

@interface NavigationTutorialViewController () <MGLMapViewDelegate>

// #-code-snippet: navigation mapview-property-objc
@property (nonatomic) MGLMapView *mapView;
// #-end-code-snippet: navigation mapview-property-objc

// #-code-snippet: navigation directions-route-objc
@property (nonatomic) MBRoute *directionsRoute;
// #-end-code-snippet: navigation directions-route-objc


@end

@implementation NavigationTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // #-code-snippet: navigation init-map-objc
    self.mapView = [[MBNavigationMapView alloc] initWithFrame:self.view.bounds styleURL: [MGLStyle streetsStyleURL]];
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
    
    // #-code-snippet: navigation call-calculate-route-objc
    [self calculateRoutefromOrigin:self.mapView.userLocation.coordinate
                     toDestination:annotation.coordinate
                        completion:^(MBRoute * _Nullable route, NSError * _Nullable error) {
                            if (error != nil) {
                                printf("Error calculating route");
                            }
                        }];
    // #-end-code-snippet: navigation call-calculate-route-objc
}
// #-end-code-snippet: navigation long-press-objc

// #-code-snippet: navigation calculate-route-objc
-(void)calculateRoutefromOrigin:(CLLocationCoordinate2D)origin
                 toDestination :(CLLocationCoordinate2D)destination
                     completion:(void(^)(MBRoute *_Nullable route, NSError *_Nullable error))completion {
    
    MBWaypoint *originWaypoint = [[MBWaypoint alloc] initWithCoordinate:origin coordinateAccuracy:-1 name:@"University of Texas at Austin"];
    
    MBWaypoint *destinationWaypoint = [[MBWaypoint alloc] initWithCoordinate:destination coordinateAccuracy:-1 name:@"Tacodeli"];
    
    MBNavigationRouteOptions *options = [[MBNavigationRouteOptions alloc] initWithWaypoints:@[originWaypoint, destinationWaypoint] profileIdentifier:MBDirectionsProfileIdentifierAutomobileAvoidingTraffic];
    
    NSURLSessionDataTask *task = [[MBDirections sharedDirections] calculateDirectionsWithOptions:options completionHandler:^(NSArray<MBWaypoint *> * _Nullable waypoints, NSArray<MBRoute *> * _Nullable routes, NSError * _Nullable error){
        
        if (!routes.firstObject) {
            return;
        }
        
        MBRoute *route = routes.firstObject;
        self.directionsRoute = route;
        CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
        [route getCoordinates:routeCoordinates];
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
        // #-code-snippet: navigation route-style-objc
        lineStyle.lineColor = [MGLStyleValue valueWithRawValue:[UIColor blueColor]];
        lineStyle.lineWidth = [MGLStyleValue valueWithRawValue:@"3"];
        // #-end-code-snippet: navigation route-style-objc
        [self.mapView.style addSource:source];
        [self.mapView.style addLayer:lineStyle];
    }
    
}
// #-end-code-snippet: navigation draw-route-objc

// #-code-snippet: navigation present-navigation-objc
-(void)presentNavigation:(MBRoute *)route {
    MBNavigationViewController *viewController = [[MBNavigationViewController alloc] initWithRoute:route
           directions:[MBDirections sharedDirections]
                style:nil
      locationManager:_mapView.locationManager];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
// #-end-code-snippet: navigation present-navigation-objc

// #-code-snippet: navigation callout-tap-objc
-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation {
    [self presentNavigation:_directionsRoute];
}
// #-end-code-snippet: navigation callout-tap-objc

@end
// #-end-code-snippet: navigation full-tutorial-objc
