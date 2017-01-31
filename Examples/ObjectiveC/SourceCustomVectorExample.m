#import "SourceCustomVectorExample.h"
@import Mapbox;

NSString *const MBXExampleSourceCustomVector = @"SourceCustomVectorExample";

@implementation SourceCustomVectorExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // In this case we're using a custom style json (https://www.mapbox.com/mapbox-gl-style-spec/) to add a third party tile source: "https://vector.mapzen.com/osm/all/{z}/{x}/{y}.mvt
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[[NSBundle mainBundle] URLForResource:@"third_party_vector_style" withExtension:@"json"]];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:mapView];
}

@end
