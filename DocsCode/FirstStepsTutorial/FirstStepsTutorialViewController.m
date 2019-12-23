#import "FirstStepsTutorialViewController.h"

@import Mapbox;
// Enable the view controller to conform to the MGLMapViewDelegate protocol
@interface FirstStepsTutorialViewController () <MGLMapViewDelegate>
@end

@implementation FirstStepsTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.74699, -73.98742)
                       zoomLevel:9
                        animated:NO];
    [self.view addSubview:mapView];
    mapView.styleURL = [MGLStyle satelliteStreetsStyleURL];

    // Add a point annotation
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(40.77014, -73.97480);
    annotation.title = @"Central Park";
    annotation.subtitle = @"The best park in New York City!";
    [mapView addAnnotation:annotation];

    // Allow the map view to display the user's location
    mapView.showsUserLocation = YES;

    // Set the map view's delegate
    mapView.delegate = self;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
}

@end
