
#import "HeatmapExample.h"
@import Mapbox;

NSString *const MBXExampleHeatmap = @"HeatmapExample";

@interface HeatmapExample () <MGLMapViewDelegate>

@end

@implementation HeatmapExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create and add a map view.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
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
    MGLHeatmapStyleLayer *layer = [[MGLHeatmapStyleLayer alloc] initWithIdentifier:@"earthquakes" source:source];
    
    // Adjust the color of the heatmap based on the density.
    NSDictionary *colorDictionary = @{ @0 : [UIColor clearColor],
                                       @0.01 : [UIColor whiteColor],
                                       @0.1 : [UIColor colorWithRed:0.19 green:0.3 blue:0.8 alpha:1.0],
                                       @0.5 : [UIColor colorWithRed:0.73 green:0.23 blue:0.25 alpha:1.0],
                                       @1 : [UIColor yellowColor]
                                       };
    layer.heatmapColor = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)", colorDictionary];

    layer.heatmapIntensity = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", @{@0: @1, @9: @3 }];
    layer.heatmapRadius = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", @{@0: @4, @9: @30}];
    layer.heatmapWeight = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", @{@0: @0, @6: @1}];
    layer.heatmapOpacity = [NSExpression expressionWithFormat:@"mgl_step:from:stops:($zoomLevel, 0.75, %@)", @{@0: @0.75, @9: @0}];
    [style addLayer:layer];
    
}

@end
