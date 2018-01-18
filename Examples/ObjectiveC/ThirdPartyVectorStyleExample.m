#import "ThirdPartyVectorStyleExample.h"
@import Mapbox;

NSString *const MBXExampleThirdPartyVectorStyle = @"ThirdPartyVectorStyleExample";

@implementation ThirdPartyVectorStyleExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Third party vector tile sources can be added.
    
    // In this case we're using custom style JSON (https://www.mapbox.com/mapbox-gl-style-spec/) to add a third party tile source from Mapillary: <https://d25uarhxywzl1j.cloudfront.net/v0.1/{z}/{x}/{y}.mvt>
    NSURL *customStyleURL = [[NSBundle mainBundle] URLForResource:@"third_party_vector_style" withExtension:@"json"];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:customStyleURL];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(60.16, 24.93) zoomLevel:12 animated:NO];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.tintColor = [UIColor whiteColor];

    [self.view addSubview:mapView];
}

@end
