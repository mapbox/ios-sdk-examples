//
//  SourceCustomRasterExample.m
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SourceCustomRasterExample.h"
@import Mapbox;

NSString *const MBXExampleSourceCustomRaster = @"SourceCustomRasterExample";

@interface SourceCustomRasterExample () <MGLMapViewDelegate>

@property (nonatomic) MGLRasterStyleLayer *rasterLayer;

@end

@implementation SourceCustomRasterExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5188, -122.6748)
		       zoomLevel:13
			animated:NO];

    [self.view addSubview:mapView];

    // Add a UISlider that will control the raster layer’s opacity.
    [self addSlider];

    mapView.delegate = self;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add a new raster source and layer.
    MGLRasterSource *source = [[MGLRasterSource alloc] initWithIdentifier:@"stamen-watercolor"
        tileURLTemplates:@[@"https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg"]
        options:@{ MGLTileSourceOptionTileSize: @256}];
    MGLRasterStyleLayer *rasterLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"stamen-watercolor" source:source];

    [[mapView style] addSource:source];
    [[mapView style] addLayer:rasterLayer];

    self.rasterLayer = rasterLayer;
}

- (void)updateLayerOpacity:(UISlider *)sender {
    [self.rasterLayer setRasterOpacity:[MGLStyleValue valueWithRawValue:@(sender.value)]];
}

- (void)addSlider {
    CGFloat padding = 10.0;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(padding, self.view.frame.size.height - 44 - 30, self.view.frame.size.width - padding * 2, 44)];
    slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value = 1;
    [slider addTarget:self action:@selector(updateLayerOpacity:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

@end
