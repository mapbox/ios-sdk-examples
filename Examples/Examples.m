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
        MBXExampleBuildings,
        MBXExampleBuildingLight,
        MBXExampleCalloutDelegateUsage,
        MBXExampleCameraAnimation,
        MBXExampleCameraFlyTo,
        MBXExampleCustomAnnotationModel,
        MBXExampleCustomCalloutView,
        MBXExampleClustering,
        MBXExampleDDSCircleLayer,
        MBXExampleDDSLayerSelection,
        MBXExampleDefaultAnnotation,
        MBXExampleDefaultStyles,
        MBXExampleDraggableAnnotationView,
        MBXExampleDrawingAGeoJSONLine,
        MBXExampleImageAnnotation,
        MBXExampleImageSource,
        MBXExampleStaticSnapshot,
        MBXExampleLiveData,
        MBXExampleOfflinePack,
        MBXExamplePointConversion,
        MBXExamplePointHotspot,
        MBXExamplePolygonAnnotation,
        MBXExamplePolygonPattern,
        MBXExampleRuntimeAddLine,
        MBXExampleRuntimeCircleStyles,
        MBXExampleSatelliteStyle,
        MBXExampleSelectFeature,
        MBXExampleShapeCollectionFeature,
        MBXExampleShowHideLayer,
        MBXExampleSimpleMapView,
        MBXExampleSourceCustomRaster,
        MBXExampleSourceCustomVector,
        MBXExampleStudioClassicStyle,
        MBXExampleStudioStyle,
        MBXExampleUserTrackingModes,
        MBXExampleWebAPIData
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
