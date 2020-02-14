//
//  Examples.h
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import <Foundation/Foundation.h>

// Steps to add a new example:
//   1. Create a new `NewExample.m` file in ../Examples/Code/Objective-C
//   2. In your new Objective-C file, add a new string constant defined as the name of the example view controller's class, e.g., `NSString *const MBXExampleSimpleMap = @"SimpleMapExample";`
//   3. Add a matching external string constant below to this Examples.h file
//   4. Add this constant to the `initialList` array in Examples.m
//   5. Create your `NewExample.swift` file in ../Examples/Code/Swift
//   6. Define the interface name of the Swift class being used in Objective-C by
//      adding the @objc attribute to your Swift file - e.g., `@objc(SimpleMapExample_Swift)`

extern NSString *const MBXExampleAddMarkerSymbol;
extern NSString *const MBXExampleAnimatedLine;
extern NSString *const MBXExampleAnnotationView;
extern NSString *const MBXExampleBlockingGesturesDelegate;
extern NSString *const MBXExampleBuildingLight;
extern NSString *const MBXExampleCameraAnimation;
extern NSString *const MBXExampleCameraFlyTo;
extern NSString *const MBXExampleClustering;
extern NSString *const MBXExampleClusteringWithImages;
extern NSString *const MBXExampleCustomCalloutView;
extern NSString *const MBXExampleDDSCircleLayer;
extern NSString *const MBXExampleDefaultCallout;
extern NSString *const MBXExampleDefaultStyles;
extern NSString *const MBXExampleDraggableAnnotationView;
extern NSString *const MBXExampleFeatureSelection;
extern NSString *const MBXExampleFormattingExpression;
extern NSString *const MBXExampleHeatmap;
extern NSString *const MBXExampleImageSource;
extern NSString *const MBXExampleLabelPlacement;
extern NSString *const MBXExampleLineStyleLayer;
extern NSString *const MBXExampleLiveData;
extern NSString *const MBXExampleMultipleImages;
extern NSString *const MBXExampleMultipleShapes;
extern NSString *const MBXExampleOfflinePack;
extern NSString *const MBXExamplePointConversion;
extern NSString *const MBXExamplePolygonPattern;
extern NSString *const MBXExampleRasterImagery;
extern NSString *const MBXExampleShowHideLayer;
extern NSString *const MBXExampleSimpleMapView;
extern NSString *const MBXExampleStaticSnapshot;
extern NSString *const MBXExampleStudioClassicStyle;
extern NSString *const MBXExampleStudioStyle;
extern NSString *const MBXExampleSwitchStyles;
extern NSString *const MBXExampleThirdPartyVectorStyle;
extern NSString *const MBXExampleUserLocationAnnotation;
extern NSString *const MBXExampleUserTrackingModes;
extern NSString *const MBXExampleWebAPIData;
extern NSString *const MBXExampleMissingIcons;
extern NSString *const MBXExampleCacheManagement;
extern NSString *const MBXExampleShapeAnnotations;

@interface Examples : NSObject

+ (NSArray *)groups;

@end
