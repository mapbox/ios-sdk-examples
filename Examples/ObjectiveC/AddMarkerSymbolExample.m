#import "AddMarkerSymbolExample.h"
@import Mapbox;

NSString *const MBXExampleAddMarkerSymbol = @"AddMarkerSymbolExample";

@interface AddMarkerSymbolExample () <MGLMapViewDelegate>
@end

@implementation AddMarkerSymbolExample 

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;

    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(41.8864, -87.7135)
                       zoomLevel:13
                        animated:NO];

    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {

    // Create point to represent where the symbol should be placed
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = mapView.centerCoordinate;

    // Create a data source to hold the point data
    MGLShapeSource *shapeSource = [[MGLShapeSource alloc] initWithIdentifier:@"marker-source" shape:point options:nil];

    // Create a style layer for the symbol
    MGLSymbolStyleLayer *shapeLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"marker-style" source:shapeSource];

    // Add the image to the style's sprite
    [style setImage:[UIImage imageNamed:@"house-icon"] forName:@"home-symbol"];

    // Tell the layer to use the image in the sprite
    shapeLayer.iconImageName = [NSExpression expressionForConstantValue:@"home-symbol"];

    // Add the source and style layer to the map
    [style addSource:shapeSource];
    [style addLayer:shapeLayer];
}

@end
