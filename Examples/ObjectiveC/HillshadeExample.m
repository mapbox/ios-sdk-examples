
#import "HillshadeExample.h"
@import Mapbox;

NSString *const MBXExampleHillshade = @"HillshadeExample";
@interface HillshadeExample () <MGLMapViewDelegate>

@end

@implementation HillshadeExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(63.6304, -19.6067) zoomLevel:8 animated:false];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.tintColor = [UIColor darkGrayColor];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL URLWithString:@"mapbox://mapbox.terrain-rgb"];
    MGLRasterDEMSource *source = [[MGLRasterDEMSource alloc] initWithIdentifier:@"terrain-rgb" configurationURL:url];
    [style addSource:source];
    
    MGLHillshadeStyleLayer *layer = [[MGLHillshadeStyleLayer alloc] initWithIdentifier:@"terrain-rgb" source:source];
    layer.hillshadeAccentColor = [NSExpression expressionForConstantValue:[UIColor lightGrayColor]];
    layer.hillshadeShadowColor = [NSExpression expressionForConstantValue:[[UIColor darkGrayColor] colorWithAlphaComponent:0.6]];
    layer.hillshadeHighlightColor = [NSExpression expressionForConstantValue:[UIColor lightGrayColor]];
    
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"waterway-river-canal"];
    [style insertLayer:layer aboveLayer:symbolLayer];
    
}
@end
