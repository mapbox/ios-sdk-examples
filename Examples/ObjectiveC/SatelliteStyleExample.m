//
//  SatelliteStyleExample.m
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SatelliteStyleExample.h"
@import Mapbox;

NSString *const MBXExampleSatelliteStyle = @"SatelliteStyleExample";

@implementation SatelliteStyleExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // A Hybrid style with unobtrusive labels is also available via +hybridStyleURL.
    NSURL *styleURL = [MGLStyle satelliteStyleURLWithVersion:9];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];

    // Tint the ℹ️ button.
    mapView.attributionButton.tintColor = [UIColor whiteColor];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's center coordinates and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5188, -122.6748)
                       zoomLevel:13
                        animated:NO];
    
    [self.view addSubview:mapView];
}

@end