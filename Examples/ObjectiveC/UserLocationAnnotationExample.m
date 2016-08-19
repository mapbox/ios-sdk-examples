//
//  UserLocationAnnotationExample.m
//  Examples
//
//  Created by Jason Wray on 8/18/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "UserLocationAnnotationExample.h"

@import Mapbox;

NSString *const MBXExampleUserLocationAnnotation = @"UserLocationAnnotationExample";

@implementation UserLocationAnnotationExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mapView];
}

@end
