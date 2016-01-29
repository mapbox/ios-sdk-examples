//
//  Examples.h
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SimpleMapViewExample.h"
#import "CustomStyleExample.h"
#import "DefaultStylesExample.h"

// Steps to add a new example:
//   1. Import NewExample.h (above)
//   2. Add `MBXExample...` string constant in NewExample.m, appending the name of the example view controller's class
//   3. Add matching external string constant (below)
//   4. Add this constant to +list in Examples.m
//   5. Create NewExample.swift, or things will get crashy (but otherwise Swift is handled automatically)

extern NSString *const MBXExampleSimpleMapView;
extern NSString *const MBXExampleCustomStyle;
extern NSString *const MBXExampleDefaultStyles;

@interface Examples : NSObject

+ (NSArray *)list;

@end
