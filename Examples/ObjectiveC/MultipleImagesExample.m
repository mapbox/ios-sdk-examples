
#import "MultipleImagesExample.h"
@import Mapbox;

NSString *const MBXExampleMultipleImages = @"MultipleImagesExample";

@interface MultipleImagesExample () <MGLMapViewDelegate>

@end

@implementation MultipleImagesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle outdoorsStyleURL]];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.7, -119.7) zoomLevel:10 animated:NO];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

@end
