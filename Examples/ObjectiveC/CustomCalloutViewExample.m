#import "CustomCalloutViewExample.h"
#import "CustomCalloutView.h"
@import Mapbox;

NSString *const MBXExampleCustomCalloutView = @"CustomCalloutViewExample";

@interface CustomCalloutViewExample () <MGLMapViewDelegate>
@end

@implementation CustomCalloutViewExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.tintColor = [UIColor darkGrayColor];
    [self.view addSubview:mapView];

    // Set the map view‘s delegate property.
    mapView.delegate = self;

    // Initialize and add the marker annotation.
    MGLPointAnnotation *marker = [[MGLPointAnnotation alloc] init];
    marker.coordinate = CLLocationCoordinate2DMake(0, 0);
    marker.title = @"Hello world!";

    // This custom callout example does not implement subtitles.
    //marker.subtitle = @"Welcome to my marker";

    // Add the annotation to the map.
    [mapView addAnnotation:marker];

    // Select the annotation so the callout will appear.
    [mapView selectAnnotation:marker animated:NO completionHandler:nil];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Only show callouts for `Hello world!` annotation.
    return [annotation respondsToSelector:@selector(title)] && [annotation.title isEqualToString:@"Hello world!"];
}

- (UIView<MGLCalloutView> *)mapView:(__unused MGLMapView *)mapView calloutViewForAnnotation:(id<MGLAnnotation>)annotation
{
    // Instantiate and return our custom callout view.
    CustomCalloutView *calloutView = [[CustomCalloutView alloc] init];
    calloutView.representedObject = annotation;
    return calloutView;
}

- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation
{
    // Optionally handle taps on the callout.
    NSLog(@"Tapped the callout for: %@", annotation);

    // Hide the callout.
    [mapView deselectAnnotation:annotation animated:YES];
}

@end
