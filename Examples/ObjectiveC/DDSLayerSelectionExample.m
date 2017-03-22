//
//  DDSLayerSelectionExample.m
//  Examples
//
//  Created by Jordan Kiley on 3/21/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

// url to use: 

#import "DDSLayerSelectionExample.h"
@import Mapbox;

NSString const *MBXExampleDDSLayerSelection = @"DDSLayerSelectionExample";

@interface DDSLayerSelectionExample () <MGLMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation DDSLayerSelectionExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.mapView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesture.delegate = self;
    gesture.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:gesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint spot = [gesture locationInView:self.mapView];
    NSArray *features = [self.mapView visibleFeaturesAtPoint:spot inStyleLayersWithIdentifiers:[NSSet setWithObject:@"state-layer"]];
    
    MGLPolygonFeature *feature = [features firstObject];
    
    NSString *state = [feature attributeForKey:@"name"];
    [self changeOpacityBasedOn:state];
}


- (void)changeOpacityBasedOn:(NSString*)name {
    MGLFillStyleLayer *layer = [self.mapView.style layerWithIdentifier:@"state-layer"];
    if ([name length] > 0) {
        layer.fillOpacity = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeCategorical sourceStops:@{name: [MGLStyleValue valueWithRawValue:@1]} attributeName:@"name" options:@{MGLStyleFunctionOptionDefaultValue: [MGLStyleValue valueWithRawValue:@0]}];
    } else {
        layer.fillOpacity = [MGLStyleValue valueWithRawValue:@1];
    }
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    NSURL *url = [NSURL URLWithString:@"mapbox://examples.69ytlgls"];
    
    MGLVectorSource *source = [[MGLVectorSource alloc] initWithIdentifier:@"state-source" configurationURL:url];
    [style addSource:source];
    
    MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"state-layer" source:source];
    layer.sourceLayerIdentifier = @"stateData_2-dx853g";
    
    NSDictionary *stops = @{
                            @0: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:0.94 green:0.93 blue:0.96 alpha:1.0]],
                            @600: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:0.62 green:0.60 blue:0.78 alpha:1.0]],
                            @1200: [MGLStyleValue valueWithRawValue:[UIColor colorWithRed:0.33 green:0.15 blue:0.56 alpha:1.0]]
                            };
    layer.fillColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential sourceStops:stops attributeName:@"density" options:@{MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:[UIColor whiteColor]]}];
    
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"place-city-sm"];
    
    [style insertLayer:layer belowLayer:symbolLayer];
}

@end
