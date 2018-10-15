#import "SimpleMapViewExample.h"
@import Mapbox;

NSString *const MBXExampleSimpleMapView = @"SimpleMapViewExample";

@interface SimpleMapViewExample () <MGLMapViewDelegate>

@end

@implementation SimpleMapViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"mapbox://styles/mapbox/cj44mfrt20f082snokim4ungi"];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:url];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(59.31, 18.06)
                       zoomLevel:9
                        animated:NO];
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

-(void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    MGLSymbolStyleLayer *labelLayer = [style layerWithIdentifier:@"place-city-lg-s"];
    labelLayer.textFontNames = [NSExpression expressionWithFormat:@"{'Roboto Medium Italic'}"];
    labelLayer.textColor = [NSExpression expressionForConstantValue:UIColor.blueColor];
}

@end
