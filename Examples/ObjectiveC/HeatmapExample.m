
#import "HeatmapExample.h"
@import Mapbox;

NSString *const MBXExampleHeatmap = @"HeatmapExample";

@interface HeatmapExample () <MGLMapViewDelegate>

@end

@implementation HeatmapExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create and add a map view.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    mapView.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Parse GeoJSON data. This example uses all M1.0+ earthquakes from 12/22/15 to 1/21/16 as logged by USGS' Earthquake hazards program.
    NSURL *url = [NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"];
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"earthquakes" URL:url options:nil];
    [mapView.style addSource:source];
    
    
    // Create a heatmap layer.
    MGLHeatmapStyleLayer *heatmapLayer = [[MGLHeatmapStyleLayer alloc] initWithIdentifier:@"earthquakes" source:source];
    
    // Adjust the color of the heatmap based on the point density.
    NSDictionary *colorDictionary = @{ @0 : [UIColor clearColor],
                                       @0.01 : [UIColor whiteColor],
                                       @0.1 : [UIColor colorWithRed:0.19f green:0.3f blue:0.8f alpha:1],
                                       @0.5 : [UIColor colorWithRed:0.73f green:0.23f blue:0.25f alpha:1],
                                       @1 : [UIColor yellowColor]
                                       };
    heatmapLayer.heatmapColor = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)", colorDictionary];

    // Heatmap weight measures how much a single data point impacts the layer's appearance.
    heatmapLayer.heatmapWeight = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", @{@0: @0, @6: @1}];
    
    // Heatmap intensity multiplies the heatmap weight based on zoom level.
    heatmapLayer.heatmapIntensity = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", @{@0: @1, @9: @3}];
    heatmapLayer.heatmapRadius = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", @{@0: @4, @9: @30}];
    
    // The heatmap layer will have an opacity of 0.75 up to zoom level 9, when the opacity becomes 0.
    heatmapLayer.heatmapOpacity = [NSExpression expressionWithFormat:@"mgl_step:from:stops:($zoomLevel, 0.75, %@)", @{@0: @0.75, @9: @0}];
    [style addLayer:heatmapLayer];
    
    // Add a circle layer to represent the earthquakes at higher zoom levels.
    MGLCircleStyleLayer *circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"circle-layer" source:source];
    
    NSDictionary *magnitudeDictionary = @{@0 : [UIColor whiteColor],
                                          @0.5 : [UIColor yellowColor],
                                          @2.5 : [UIColor colorWithRed:0.73f green:0.23f blue:0.25f alpha:1],
                                          @5 : [UIColor colorWithRed:0.19f green:0.30f blue:0.80f alpha:1]
                                          };
    circleLayer.circleColor = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", magnitudeDictionary];
    
    // The circle layer becomes visible at zoom level 9.
    circleLayer.circleOpacity = [NSExpression expressionWithFormat:@"mgl_step:from:stops:($zoomLevel, 0, %@)", @{@0: @0, @9: @0.75}];
    circleLayer.circleRadius = [NSExpression expressionForConstantValue:@20];
    [style addLayer:circleLayer];
}

@end
