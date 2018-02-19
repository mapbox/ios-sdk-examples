//
//  Examples.m
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "Examples.h"

@implementation Examples

+ (NSArray *)list {
    
    NSArray *initialList = [[NSMutableArray alloc] initWithArray:@[
        MBXExampleAnimatedLine,
        MBXExampleAnnotationView,
        MBXExampleAnnotationViewsAndImagesExample,
        MBXExampleBlockingGesturesDelegate,
        MBXExampleBuildingLight,
        MBXExampleBuildings,
        MBXExampleCalloutDelegateUsage,
        MBXExampleCameraAnimation,
        MBXExampleCameraFlyTo,
        MBXExampleClustering,
        MBXExampleCustomAnnotationModel,
        MBXExampleCustomCalloutView,
        MBXExampleDDSCircleLayer,
        MBXExampleDefaultAnnotation,
        MBXExampleDefaultStyles,
        MBXExampleDraggableAnnotationView,
        MBXExampleFeatureSelection,
        MBXExampleImageAnnotation,
        MBXExampleImageSource,
        MBXExampleLineAnnotationGeoJSON,
        MBXExampleLineStyleLayer,
        MBXExampleLiveData,
        MBXExampleMultipleImages,
        MBXExampleMultipleShapes,
        MBXExampleOfflinePack,
        MBXExamplePointConversion,
        MBXExamplePointHotspot,
        MBXExamplePolygonAnnotation,
        MBXExamplePolygonPattern,
        MBXExampleRasterImagery,
        MBXExampleRuntimeCircleStyles,
        MBXExampleSatelliteStyle,
        MBXExampleSelectFeature,
        MBXExampleShowHideLayer,
        MBXExampleSimpleMapView,
        MBXExampleStaticSnapshot,
        MBXExampleStudioClassicStyle,
        MBXExampleStudioStyle,
        MBXExampleSwitchStyles,
        MBXExampleThirdPartyVectorStyle,
        MBXExampleUserLocationAnnotation,
        MBXExampleUserTrackingModes,
        MBXExampleWebAPIData,
    ]];

    NSMutableArray *meh = [[NSMutableArray alloc] init];
    
    [initialList enumerateObjectsUsingBlock:^(NSString *objcName, NSUInteger index, BOOL *stop) {
        NSString *swiftName = [NSString stringWithFormat:@"%@_Swift", objcName];
        
        [meh insertObject:swiftName atIndex:index*2];
        [meh insertObject:objcName atIndex:index*2];
    }];
    
    return [meh copy];
}

@end
