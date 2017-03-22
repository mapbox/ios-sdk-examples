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
@property (nonatomic) Boolean *isStateSelected;

@end

@implementation DDSLayerSelectionExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.mapView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    gesture.delegate = self;
    [self.mapView addGestureRecognizer:gesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint spot = [gesture locationInView:self.mapView];
    NSArray *features = [self.mapView visibleFeaturesAtPoint:spot];
    
    MGLPolygonFeature *feature = [features firstObject];
    
    NSString *state = [feature attributeForKey:@"name"];
}

// JK - I need to put in a block?
- (void)changeOpacityForFeatureWith:(NSString*)name completion:^(BOOL finished) {
    
}
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
}

@end
