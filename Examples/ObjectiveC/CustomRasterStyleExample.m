//
//  CustomRasterStyleExample.m
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CustomRasterStyleExample.h"
@import Mapbox;

NSString *const MBXExampleCustomRasterStyle = @"CustomRasterStyleExample";

@implementation CustomRasterStyleExample

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *styleURL = [NSURL URLWithString:@"https://www.mapbox.com/ios-sdk/files/mapbox-raster-v8.json"];
    // local paths are also acceptable

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:styleURL];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:mapView];
}

@end
