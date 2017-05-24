
#import "PointHeatmapExample.h"
@import Mapbox;

NSString *const MBXExamplePointHeatmap = @"PointHeatmapExample";

@interface PointHeatmapExample () <MGLMapViewDelegate>

@end

@implementation PointHeatmapExample

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

    // Create a stops dictionary. The keys represent the number of points in a cluster.
    NSDictionary *stops = @{
                            @0: [MGLStyleValue valueWithRawValue:[UIColor yellowColor]],
                            @20.0: [MGLStyleValue valueWithRawValue:[UIColor orangeColor]],
                            @150.0: [MGLStyleValue valueWithRawValue:[UIColor redColor]],
                            };
    
    
    // Create and style the clustered circle layer.
    MGLCircleStyleLayer *clusteredLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clustered layer" source:earthquakeSource];
    clusteredLayer.circleColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential
                                                sourceStops:stops
                                                attributeName:@"point_count"
                                                options:@{MGLStyleFunctionOptionDefaultValue: [MGLConstantStyleValue valueWithRawValue:[UIColor yellowColor]]}];
    
    clusteredLayer.circleRadius = [MGLConstantStyleValue valueWithRawValue:@70];
    clusteredLayer.circleOpacity = [MGLConstantStyleValue valueWithRawValue:@0.5];
    clusteredLayer.circleBlur = [MGLConstantStyleValue valueWithRawValue:@1];
    
    [style insertLayer:clusteredLayer belowLayer:symbolLayer];
}

@end
