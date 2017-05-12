//
//  PointHeatmapExample.m
//  Examples
//
//  Created by Jordan Kiley on 4/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

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
    
    // Parse GeoJSON data from USGS on earthquakes in the past week.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayEarthquakesFrom:url with:style];
        });
    });
}

- (void)displayEarthquakesFrom:(NSURL *)url with:(MGLStyle *)style {
    
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
                            @0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1]],
                            @20.0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:249/255.0 green:136/255.0 blue:108/255.0 alpha:1]],
                            @150.0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:229/255.0 green:94/255.0 blue:94/255.0 alpha:1]],
                            };
    
    
    MGLCircleStyleLayer *clusteredLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clustered layer" source:earthquakeSource];
    clusteredLayer.circleColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential
                                                        sourceStops:stops
                                                      attributeName:@"point_count"
                                                            options:@{MGLStyleFunctionOptionDefaultValue: [MGLConstantStyleValue valueWithRawValue:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1]]}];
    clusteredLayer.circleRadius = [MGLConstantStyleValue valueWithRawValue:@70];
    clusteredLayer.circleBlur = [MGLConstantStyleValue valueWithRawValue:@1];
    [style insertLayer:clusteredLayer belowLayer:symbolLayer];
}

@end
