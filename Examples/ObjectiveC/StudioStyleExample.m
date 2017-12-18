#import "StudioStyleExample.h"
@import Mapbox;

NSString *const MBXExampleStudioStyle = @"StudioStyleExample";

@implementation StudioStyleExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Replace the string in the URL below with your custom style URL from Mapbox Studio.
    // Read more about style URLs here: https://www.mapbox.com/help/define-style-url/
    NSURL *styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/outdoors-v9"];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                                   styleURL:styleURL];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.52954, -122.72317)
                       zoomLevel:14
                        animated:NO];

    [self.view addSubview:mapView];
}

@end
