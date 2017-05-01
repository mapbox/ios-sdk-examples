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
    MGLShapeSource *symbolSource = [[MGLSource alloc] initWithIdentifier:@"symbol-source"];
    MGLSymbolStyleLayer *symbolLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"place-city-sm" source:symbolSource];
    
    NSURL *url = [NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"];
    NSDictionary *options = @{
                              MGLShapeSourceOptionClustered : @TRUE,
                              MGLShapeSourceOptionClusterRadius : @20,
                              MGLShapeSourceOptionMaximumZoomLevel : @15
                            };
    
    MGLShapeSource *earthquakeSource = [[MGLShapeSource alloc] initWithIdentifier:@"earthquakes" URL:url options:options];
    [style addSource:earthquakeSource];
    
    MGLCircleStyleLayer *unclusteredLayer = [[MGLCircleStyleLayer alloc]initWithIdentifier:@"unclustered" source:earthquakeSource];
    
}

@end
