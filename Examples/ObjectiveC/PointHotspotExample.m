
#import "PointHotspotExample.h"
@import Mapbox;

NSString *const MBXExamplePointHotspot = @"PointHotspotExample";

@interface PointHotspotExample () <MGLMapViewDelegate>

@end

@implementation PointHotspotExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.frame styleURL:[MGLStyle darkStyleURLWithVersion:9]];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
   // Parse GeoJSON data. This example uses all M1.0+ earthquakes from 12/22/15 to 1/21/16 as logged by USGS' Earthquake hazards program.
        NSURL *url = [NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"];

    MGLShapeSource *symbolSource = [[MGLShapeSource alloc] initWithIdentifier:@"symbol-source"];
    MGLSymbolStyleLayer *symbolLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"place-city-sm" source:symbolSource];
    
    // Set the MGLShapeSourceOptions to allow clustering.
    NSDictionary *options = @{
                              MGLShapeSourceOptionClustered : @TRUE,
                              MGLShapeSourceOptionClusterRadius : @20,
                              MGLShapeSourceOptionMaximumZoomLevel : @15
                              };
    
    MGLShapeSource *earthquakeSource = [[MGLShapeSource alloc] initWithIdentifier:@"earthquakes" URL:url options:options];
    [style addSource:earthquakeSource];
    
    // Create and style the clustered circle layer.
    MGLCircleStyleLayer *clusteredLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clustered layer" source:earthquakeSource];
    
    // Create a stops dictionary. The keys represent the number of points in a cluster. Use the dictionary to determine the cluster color.
    NSDictionary *stops = @{
                            @0: [UIColor yellowColor],
                            @20.0: [UIColor orangeColor],
                            @150.0: [UIColor redColor],
                            };
    clusteredLayer.circleColor = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(point_count, 'linear', nil, %@)", stops];
    clusteredLayer.circleRadius = [NSExpression expressionForConstantValue:@70];
    clusteredLayer.circleOpacity = [NSExpression expressionForConstantValue:@0.5];
    clusteredLayer.circleBlur = [NSExpression expressionForConstantValue:@1];
    
    [style insertLayer:clusteredLayer belowLayer:symbolLayer];
}

@end
