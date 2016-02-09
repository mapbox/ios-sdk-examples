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

@implementation CameraAnimationExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(50.999, 3.3253);

    // Optionally set a starting point, rotated 180°.
    [mapView setCenterCoordinate:center zoomLevel:5 direction:180 animated:NO];

    [self.view addSubview:mapView];

    // Create a camera that rotates around the same center point, back to 0°.
    // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:center fromDistance:9000 pitch:45 heading:0];

    // Animate the camera movement over 5 seconds.
    [mapView setCamera:camera withDuration:5 animationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
}

@end
