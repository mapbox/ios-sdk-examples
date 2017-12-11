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

extern NSString *const MBXExampleAnnotationView;
extern NSString *const MBXExampleAnnotationViewsAndImagesExample;
extern NSString *const MBXExampleBlockingGesturesDelegate;
extern NSString *const MBXExampleCalloutDelegateUsage;
extern NSString *const MBXExampleCameraAnimation;
extern NSString *const MBXExampleCameraFlyTo;
extern NSString *const MBXExampleCustomAnnotationModel;
extern NSString *const MBXExampleCustomCalloutView;
extern NSString *const MBXExampleClustering;
extern NSString *const MBXExampleCustomRasterStyle;
extern NSString *const MBXExampleDDSCircleLayer;
extern NSString *const MBXExampleDDSLayerSelection;
extern NSString *const MBXExampleDefaultStyles;
extern NSString *const MBXExampleDraggableAnnotationView;
extern NSString *const MBXExampleDrawingAGeoJSONLine;
extern NSString *const MBXExampleDrawingACustomMarker;
extern NSString *const MBXExampleDrawingAMarker;
extern NSString *const MBXExampleDrawingAPolygon;
extern NSString *const MBXExample3DExtrusions;
extern NSString *const MBXExampleImageSource;
extern NSString *const MBXExampleLight;
extern NSString *const MBXExampleFillPattern;
extern NSString *const MBXExampleLiveData;
extern NSString *const MBXExampleMapSnapshotter;
extern NSString *const MBXExampleOfflinePack;
extern NSString *const MBXExamplePointConversion;
extern NSString *const MBXExamplePointHotspot;
extern NSString *const MBXExampleRuntimeAddLine;
extern NSString *const MBXExampleRuntimeAnimateLine;
extern NSString *const MBXExampleRuntimeCircleStyles;
extern NSString *const MBXExampleRuntimeToggleLayer;
extern NSString *const MBXExampleRuntimeMultipleAnnotations;
extern NSString *const MBXExampleSatelliteStyle;
extern NSString *const MBXExampleSelectFeature;
extern NSString *const MBXExampleShapeCollectionFeature;
extern NSString *const MBXExampleSimpleMapView;
extern NSString *const MBXExampleSourceCustomRaster;
extern NSString *const MBXExampleSourceCustomVector;
extern NSString *const MBXExampleStudioStyle;
extern NSString *const MBXExampleUserTrackingModes;

@interface Examples : NSObject

+ (NSArray *)list;

@end
