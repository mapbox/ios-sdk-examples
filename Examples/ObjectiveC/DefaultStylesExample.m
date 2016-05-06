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
                                                   styleURL:[MGLStyle outdoorsStyleURLWithVersion:9]];

    // Tint the ℹ️ button and the user location annotation.
    mapView.tintColor = [UIColor darkGrayColor];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // set the map's center coordinate and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(51.50713, -0.10957)
                       zoomLevel:13
                        animated:NO];

    [self.view addSubview:mapView];
}

@end
