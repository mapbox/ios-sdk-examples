//
//  SimpleMapViewExample.m
//  Examples
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SimpleMapViewExample.h"
@import Mapbox;

NSString *const MBXExampleSimpleMapView = @"SimpleMapViewExample";

@implementation SimpleMapViewExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // set the map’s center coordinates and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(59.31, 18.06)
                       zoomLevel:9
                        animated:NO];

    [self.view addSubview:mapView];
}

@end