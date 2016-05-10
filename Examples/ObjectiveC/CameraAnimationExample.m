//
//  CameraAnimationExample.m
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CameraAnimationExample.h"
@import Mapbox;

NSString *const MBXExampleCameraAnimation = @"CameraAnimationExample";

@interface CameraAnimationExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation CameraAnimationExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;

    self.mapView.styleURL = [MGLStyle outdoorsStyleURLWithVersion:9];

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(19.820689, -155.468038);

    // Optionally set a starting point.
    [self.mapView setCenterCoordinate:center zoomLevel:7 direction:0 animated:NO];

    [self.view addSubview:self.mapView];
}

-(void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    // Wait for the map to load before initiating the first camera movement.

    // Create a camera that rotates around the same center point, rotating 180°.
    // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:self.mapView.centerCoordinate fromDistance:4500 pitch:15 heading:180];

    // Animate the camera movement over 5 seconds.
    [self.mapView setCamera:camera withDuration:5 animationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
}

@end
