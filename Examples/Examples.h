//
//  Examples.h
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import <Foundation/Foundation.h>

// Steps to add a new example:
//   1. Add `MBXExample...` string constant in NewExample.m, defined as the name of the example view controller's class
//   2. Add matching external string constant below
//   3. Add this constant to +list in Examples.m
//   4. Create NewExample.swift (otherwise Swift is handled automatically)

extern NSString *const MBXExampleSimpleMapView;
extern NSString *const MBXExampleCustomStyle;
extern NSString *const MBXExampleDefaultStyles;
extern NSString *const MBXExampleCustomRasterStyle;
extern NSString *const MBXExampleSatelliteStyle;
extern NSString *const MBXExampleDrawingAMarker;
extern NSString *const MBXExampleCalloutDelegateUsage;

@interface Examples : NSObject

+ (NSArray *)list;

@end
