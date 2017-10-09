#import "FirstStepsTutorialViewController.h"

@import Mapbox;
// Enable the view controller to conform to the MGLMapViewDelegate protocol
@interface FirstStepsTutorialViewController () <MGLMapViewDelegate>
@end

@implementation FirstStepsTutorialViewController

- (void)viewDidLoad {
    // code-snippet: first-steps-ios-sdk initialize-map
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.74699, -73.98742)
                       zoomLevel:9
                        animated:NO];
    [self.view addSubview:mapView];
    // #-end-code-snippet
    
    // code-snippet: first-steps-ios-sdk change-style
    mapView.styleURL = [MGLStyle satelliteStreetsStyleURL];
    // #-end-code-snippet
    
    // code-snippet: first-steps-ios-sdk add-annotation
    // Add a point annotation
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(40.77014, -73.97480);
    annotation.title = @"Central Park";
    annotation.subtitle = @"The best park in New York City!";
    [mapView addAnnotation:annotation];
    // #-end-code-snippet
    
    // code-snippet: first-steps-ios-sdk show-location
    // Allow the map view to display the user's location
    mapView.showsUserLocation = YES;
    // #-end-code-snippet
    
    // code-snippet: first-steps-ios-sdk set-delegate
    // Set the map view's delegate
    mapView.delegate = self;
    // #-end-code-snippet
}

// code-snippet: first-steps-ios-sdk add-callout
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
// #-end-code-snippet
}

@end
