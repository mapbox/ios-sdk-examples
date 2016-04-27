//
//  DefaultStylesExample.m
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "DefaultStylesExample.h"
@import Mapbox;

NSString *const MBXExampleDefaultStyles = @"DefaultStylesExample";

@implementation DefaultStylesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                                   styleURL:[MGLStyle lightStyleURL]];

    // Tint the ℹ️ button and the user location annotation.
    mapView.tintColor = [UIColor darkGrayColor];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // set the map's center coordinate and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                       zoomLevel:12
                        animated:NO];

    [self.view addSubview:mapView];
}

@end
