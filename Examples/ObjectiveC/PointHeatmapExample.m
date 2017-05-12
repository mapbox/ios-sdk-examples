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
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.frame];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
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
    
   
    NSDictionary *options = @{
                              MGLShapeSourceOptionClustered : @TRUE,
                              MGLShapeSourceOptionClusterRadius : @20,
                              MGLShapeSourceOptionMaximumZoomLevel : @15
                            };
    
    MGLShapeSource *earthquakeSource = [[MGLShapeSource alloc] initWithIdentifier:@"earthquakes" URL:url options:options];
    [style addSource:earthquakeSource];
    
    MGLCircleStyleLayer *unclusteredLayer = [[MGLCircleStyleLayer alloc]initWithIdentifier:@"unclustered" source:earthquakeSource];
    
    unclusteredLayer.circleColor = [MGLConstantStyleValue valueWithRawValue: [UIColor colorWithRed:229/255.0 green:94/255.0 blue:94/255.0 alpha:1]];
    unclusteredLayer.circleRadius = [MGLConstantStyleValue valueWithRawValue:@20];
    unclusteredLayer.circleBlur = [MGLConstantStyleValue valueWithRawValue:@15];
    unclusteredLayer.predicate = [NSPredicate predicateWithFormat:@"%K != YES" argumentArray:@[@"cluster"]];
    [style insertLayer:unclusteredLayer belowLayer:symbolLayer];
    
    NSDictionary *stops = @{
                            @0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1]],
                            @20.0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:249/255.0 green:136/255.0 blue:108/255.0 alpha:1]],
                            @150.0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:229/255.0 green:94/255.0 blue:94/255.0 alpha:1]],
                            };
    MGLCircleStyleLayer *circles = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"clustered layer" source:earthquakeSource];
    circles.circleColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential
                                sourceStops:stops
                                attributeName:@"point_count"
                                                            options:@{MGLStyleFunctionOptionDefaultValue: [MGLConstantStyleValue valueWithRawValue:[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1]]}];
    circles.circleRadius = [MGLConstantStyleValue valueWithRawValue:@70];
    circles.circleBlur = [MGLConstantStyleValue valueWithRawValue:@1];
    [style insertLayer:circles belowLayer:symbolLayer];
}

@end
