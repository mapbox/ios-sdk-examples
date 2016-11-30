//
//  RuntimeAddLineExample.m
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "RuntimeAddLineExample.h"
@import Mapbox;

NSString *const MBXExampleRuntimeAddLine = @"RuntimeAddLineExample";

@interface RuntimeAddLineExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation RuntimeAddLineExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map's center coordinate
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736)
			    zoomLevel:11
			     animated:NO];

    [self.view addSubview:self.mapView];

    // Set the delegate property of our map view to self after instantiating it
    self.mapView.delegate = self;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self loadGeoJson];
}

- (void)loadGeoJson {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"geojson"];
	NSData *jsonData = [NSData dataWithContentsOfFile:path];
	dispatch_async(dispatch_get_main_queue(), ^{
	    [self drawPolyline:jsonData];
	});
    });
}

- (void)drawPolyline:(NSData *)geoJson {
    MGLSource *source = [[MGLGeoJSONSource alloc] initWithIdentifier:@"polyline" geoJSONData:geoJson options:nil];

    NSDictionary *lineWidthStops = @{
	@14: [MGLStyleValue valueWithRawValue: @2],
	@18: [MGLStyleValue valueWithRawValue: @20]
    };

    NSDictionary *casingLineWidthStops = @{
	@14: [MGLStyleValue valueWithRawValue: @1],
	@18: [MGLStyleValue valueWithRawValue: @4]
    };

    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    layer.lineJoin = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLLineJoin:MGLLineJoinRound]];
    layer.lineCap = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLLineCap:MGLLineCapRound]];
    layer.lineColor = [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:59/255.0 green:178/255.0 blue:208/255.0 alpha:1]];
    layer.lineWidth = [MGLStyleValue valueWithBase:1.5 stops: lineWidthStops];

    MGLLineStyleLayer *casingLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline-case" source:source];
    casingLayer.lineJoin = layer.lineJoin;
    casingLayer.lineCap = layer.lineCap;
    casingLayer.lineColor = [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:41/255.0 green:145/255.0 blue:171/255.0 alpha:1]];
    casingLayer.lineGapWidth = layer.lineWidth;
    casingLayer.lineWidth = [MGLStyleValue valueWithBase:1.5 stops: casingLineWidthStops];

    [self.mapView.style addSource:source];
    [self.mapView.style addLayer:layer];
    [self.mapView.style insertLayer:casingLayer belowLayer:layer];
}

@end
