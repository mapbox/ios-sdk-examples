//
//  LightExample.m
//  Examples
//
//  Created by Jordan Kiley on 6/22/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

#import "LightExample.h"
@import Mapbox;

@interface LightExample () <MGLMapViewDelegate>

@end

NSString *const MBXExampleLight = @"LightExample";

@implementation LightExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    mapView.delegate = self;
    
    // Center the map on the Flatiron Building in New York, NY.
    mapView.camera = [MGLMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.7411, -73.9897) fromDistance:600 pitch:45 heading:200];
    mapView.tintColor = [UIColor grayColor];
    
    [self.view addSubview:mapView];
    
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Add a MGLFillExtrusionStyleLayer.
    [self addFillExtrusionLayer:style];
    
    // Create an MGLLight object.
    MGLLight *light = [[MGLLight alloc] init];
    
    // Create an MGLSphericalPosition and set the radial, azimuthal, and polar values.
    MGLSphericalPosition position = MGLSphericalPositionMake(5, 180, 80);
    light.position = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLSphericalPosition:position]];
    
    // Set the light anchor to the map and add the light object to the map view's style.
    light.anchor = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLLightAnchor:MGLLightAnchorMap]];
    style.light = light;
    
}

- (void)addFillExtrusionLayer:(MGLStyle *)style {
    // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
    MGLSource *source = [style sourceWithIdentifier:@"composite"];
    MGLFillExtrusionStyleLayer *layer = [[MGLFillExtrusionStyleLayer alloc] initWithIdentifier:@"extrusion-layer" source:source];
    layer.sourceLayerIdentifier = @"building";
    layer.fillExtrusionBase = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeIdentity
                                                            sourceStops:nil
                                                          attributeName:@"min_height"
                                                                options:nil];
    layer.fillExtrusionHeight = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeIdentity sourceStops:nil attributeName:@"height" options:nil];
    layer.fillExtrusionOpacity = [MGLStyleValue valueWithRawValue:@0.75];
    layer.fillExtrusionColor = [MGLStyleValue valueWithRawValue:[UIColor whiteColor]];
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"poi-scalerank3"];
    [style insertLayer:layer belowLayer:symbolLayer];
    
}
@end
