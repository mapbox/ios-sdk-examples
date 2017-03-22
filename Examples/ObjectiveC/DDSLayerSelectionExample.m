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
@property (nonatomic) BOOL *isStateSelected;

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
    [self.mapView addGestureRecognizer:gesture];
    self.isStateSelected = FALSE;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint spot = [gesture locationInView:self.mapView];
    NSArray *features = [self.mapView visibleFeaturesAtPoint:spot];
    
    MGLPolygonFeature *feature = [features firstObject];
    
    NSString *state = [feature attributeForKey:@"name"];
    [self changeOpacityBasedOn:state withCompletion:^(BOOL finished) {
        self.isStateSelected = !self.isStateSelected;
    }];
}


- (void)changeOpacityBasedOn:(NSString*)name withCompletion:(void(^)(BOOL finished))completionHandler {
    MGLFillStyleLayer *layer = [self.mapView.style layerWithIdentifier:@"state-layer"];
    if (!self.isStateSelected) {
        layer.fillOpacity = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeCategorical sourceStops:@{name: [MGLStyleValue valueWithRawValue:@1]} attributeName:@"name" options:@{MGLStyleFunctionOptionDefaultValue: [MGLStyleValue valueWithRawValue:@0]}];
    } else {
        layer.fillOpacity = [MGLStyleValue valueWithRawValue:@1];
    }
    completionHandler(TRUE);
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    NSURL *url = [NSURL URLWithString:@"mapbox://examples.69ytlgls"];
    
    MGLVectorSource *source = [[MGLVectorSource alloc] initWithIdentifier:@"state-source" configurationURL:url];
    [style addSource:source];
    
    MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"state-layer" source:source];
    layer.sourceLayerIdentifier = @"stateData_2-dx853g";
    
    NSDictionary *stops = @{
                            @0: [MGLStyleValue valueWithRawValue:[UIColor yellowColor]],
                            @100: [MGLStyleValue valueWithRawValue:[UIColor redColor]],
                            @1200: [MGLStyleValue valueWithRawValue:[UIColor blueColor]]
                            };
    layer.fillColor = [MGLStyleValue valueWithInterpolationMode:MGLInterpolationModeExponential sourceStops:stops attributeName:@"density" options:@{MGLStyleFunctionOptionDefaultValue : [MGLStyleValue valueWithRawValue:[UIColor whiteColor]]}];
    
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"state-label-sm"];
    
    [style insertLayer:layer belowLayer:symbolLayer];
}

@end
