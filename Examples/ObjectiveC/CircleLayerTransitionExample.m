#import "CircleLayerTransitionExample.h"
@import Mapbox;

NSString *const MBXExampleCircleLayerTransition = @"CircleLayerTransitionExample";

@interface CircleLayerTransitionExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation CircleLayerTransitionExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Outdoors style.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                            styleURL:[MGLStyle outdoorsStyleURL]];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map’s center coordinate and zoom level.
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(28.437,-81.91);
    self.mapView.zoomLevel = 6;
    
    self.mapView.delegate = self;
    [self.view addSubview: self.mapView];
}

@end
