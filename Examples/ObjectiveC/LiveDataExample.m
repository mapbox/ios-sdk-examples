//
//  LiveDataExample.m
//  Examples
//
//  Created by Jordan Kiley on 6/7/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

#import "LiveDataExample.h"
@import Mapbox;

NSString *const MBXExampleLiveData = @"LiveDataExample";

@interface LiveDataExample () <MGLMapViewDelegate>

@end

@implementation LiveDataExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    
    mapView.tintColor = [UIColor darkGrayColor];
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL URLWithString:@"https://wanderdrone.appspot.com/"];
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"drone-source" URL:url options:nil];
    [style addSource:source];
    
    MGLSymbolStyleLayer *droneLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"drone-layer" source:source];
    droneLayer.iconImageName = [MGLStyleValue valueWithRawValue:@"rocket-15"];
    [style addLayer:droneLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        source.URL = url;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}
@end
