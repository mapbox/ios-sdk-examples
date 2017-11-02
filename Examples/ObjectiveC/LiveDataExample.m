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

@property (nonatomic, strong, nullable) NSTimer *timer;
@property MGLShapeSource *source;
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
    _source = [[MGLShapeSource alloc] initWithIdentifier:@"drone-source" URL:url options:nil];
    [style addSource:_source];
    
    MGLSymbolStyleLayer *droneLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"drone-layer" source:_source];
    droneLayer.iconImageName = [MGLStyleValue valueWithRawValue:@"rocket-15"];
    [style addLayer:droneLayer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateURL) userInfo:nil repeats:YES];
}

- (void)updateURL {
    NSURL *url = [NSURL URLWithString:@"https://wanderdrone.appspot.com/"];
    _source.URL = url;
}
- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
}
@end
