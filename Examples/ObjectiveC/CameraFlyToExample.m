//
//  CameraFlyToViewController.m
//  Examples
//
//  Created by Jordan Kiley on 12/13/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CameraFlyToExample.h"

NSString const *MBXExampleCameraFlyTo = @"CameraFlyToExample";

@interface CameraFlyToExample ()

@end

@implementation CameraFlyToExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the MGLMapView
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    
    // Centers the mapView on Honololu
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(21.3069, -157.8583)
                       zoomLevel:14 animated:NO];
    
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    
    // Waits for the mapView to finish loading before setting up the camera
    // Defines the destination camera as Hawaii Island
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(19.503148, -155.489776) fromDistance:270000 pitch:10 heading:10];
    
    // The mapView flyToCamera goes from the origin to destination camera. Set duration in seconds
    [mapView flyToCamera:camera withDuration:5.0 peakAltitude:4500 completionHandler:^{
        
    }];
}
@end
