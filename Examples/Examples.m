//
//  Examples.m
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "Examples.h"

@implementation Examples

+ (NSArray *)groups {
    NSArray *initialList = [[NSMutableArray alloc] initWithArray:@[
        @{
            @"title": @"Getting started",
            @"examples": @[
                    @{@"className": MBXExampleCameraAnimation, @"title": @"Camera animation"},
                    @{@"className": MBXExampleStudioStyle, @"title": @"Apply a style designed in Mapbox Studio"},
                    @{@"className": MBXExampleDefaultAnnotation, @"title": @"Mark a place on the map with an annotation"},
                    @{@"className": MBXExampleSimpleMapView, @"title": @"Simple map view"},
            ]
        },
        @{
            @"title": @"Map styles",
            @"examples": @[
                    @{@"className": MBXExampleDefaultStyles, @"title": @"Default styles"},
                    @{@"className": MBXExampleStudioClassicStyle, @"title": @"Apply a style designed in Mapbox Studio Classic"},
                    @{@"className": MBXExampleSatelliteStyle, @"title": @"Satellite styles"},
                    @{@"className": MBXExampleThirdPartyVectorStyle, @"title": @"Use third-party vector tiles"},
                    @{@"className": MBXExampleSwitchStyles, @"title": @"Switch between map styles"},
                    @{@"className": MBXExampleCameraFlyTo, @"title": @"Camera fly to"},
            ]
        },
        @{
            @"title": @"Annotations",
            @"examples": @[
                    @{@"className": MBXExampleCustomAnnotationModel, @"title": @"Annotation models"},
                    @{@"className": MBXExampleAnnotationViewsAndImagesExample, @"title": @"Add annotation views and images"},
                    @{@"className": MBXExampleAnnotationView, @"title": @"Annotation views"},
                    @{@"className": MBXExampleDefaultCallout, @"title": @"Use the default callout"},
                    @{@"className": MBXExampleCustomCalloutView, @"title": @"Display custom views as callouts"},
                    @{@"className": MBXExampleImageAnnotation, @"title": @"Mark a place on the map with an image"},
                    @{@"className": MBXExampleWebAPIData, @"title": @"Dynamically style interactive points"},
                    @{@"className": MBXExampleUserLocationAnnotation, @"title": @"Customize the user location annotation"},
            ]
        },
        @{
            @"title": @"Markers and callouts",
            @"examples": @[
                    @{@"className": MBXExamplePolygonPattern, @"title": @"Add a pattern to a polygon"},
                    @{@"className": MBXExampleLineAnnotationGeoJSON, @"title": @"Add a line annotation from GeoJSON"},
                    @{@"className": MBXExamplePolygonAnnotation, @"title": @"Add a polygon annotation"},
                    @{@"className": MBXExampleLineStyleLayer, @"title": @"Add a line style layer from GeoJSON"},
                    @{@"className": MBXExampleAnimatedLine, @"title": @"Animate a line"},
            ]
        },
        @{
            @"title": @"User interaction",
            @"examples": @[
                    @{@"className": MBXExampleBlockingGesturesDelegate, @"title": @"Restrict map panning to an area"},
                    @{@"className": MBXExampleDraggableAnnotationView, @"title": @"Draggable annotation views"},
                    @{@"className": MBXExamplePointConversion, @"title": @"Point conversion"},
                    @{@"className": MBXExampleShowHideLayer, @"title": @"Show and hide a layer"},
                    @{@"className": MBXExampleFeatureSelection, @"title": @"Select a feature within a layer"},
                    @{@"className": MBXExampleSelectFeature, @"title": @"Select a water feature"},
                    @{@"className": MBXExampleUserTrackingModes, @"title": @"Switch between user tracking modes"},
                    @{@"className": MBXExampleOrnamentsLayout, @"title": @"Ornaments layout"}
                    ]
        },
        @{
            @"title": @"Dynamic styling",
            @"examples": @[
                    @{@"className": MBXExampleClustering, @"title": @"Cluster point data"},
                    @{@"className": MBXExampleClusteringWithImages, @"title": @"Cluster point data with images"},
                    @{@"className": MBXExampleDDSCircleLayer, @"title": @"Data-driven circles"},
                    @{@"className": MBXExampleHeatmap, @"title": @"Add a heatmap layer"},
                    @{@"className": MBXExampleImageSource, @"title": @"Add an image"},
                    @{@"className": MBXExampleLiveData, @"title": @"Add live data"},
                    @{@"className": MBXExampleMultipleShapes, @"title": @"Add multiple shapes from a single shape source"},
                    @{@"className": MBXExampleMultipleImages, @"title": @"Add multiple images"},
                    @{@"className": MBXExampleRasterImagery, @"title": @"Add raster imagery"},
                    @{@"className": MBXExamplePointHotspot, @"title": @"Add point hotspot"},
            ]
        },
        @{
            @"title": @"3D",
            @"examples": @[
                    @{@"className": MBXExampleBuildings, @"title": @"Display 3D buildings"},
                    @{@"className": MBXExampleBuildingLight, @"title": @"Adjust lighting of 3D buildings"},
            ]
        },
        @{
            @"title": @"Offline",
            @"examples": @[
                    @{@"className": MBXExampleStaticSnapshot, @"title": @"Create a static map snapshot"},
                    @{@"className": MBXExampleOfflinePack, @"title": @"Download an offline map"},
            ]
        },
        @{
            @"title": @"Advanced",
            @"examples": @[
                    @{@"className": MBXExampleCacheManagement, @"title": @"Use cache management methods"},
            ]
        },
        @{
            @"title": @"Works in progress",
            @"examples": @[
                    @{@"className": MBXExampleFormattingExpression, @"title": @"Format label text"},
                    @{@"className": MBXExampleLabelPlacement, @"title": @"Change label placement"},
                    @{@"className": MBXExampleMissingIcons, @"title": @"Load missing style icons"},
            ]
        }
    ]];

    NSMutableArray *objcCategories = [[NSMutableArray alloc] init];
    NSMutableArray *swiftCategories = [[NSMutableArray alloc] init];
    
    [initialList enumerateObjectsUsingBlock:^(NSDictionary *category, NSUInteger index, BOOL *stop) {
        NSMutableArray *objcExamples = [[NSMutableArray alloc] init];
        NSMutableArray *swiftExamples = [[NSMutableArray alloc] init];
        
        NSArray *examples = category[@"examples"];
        [examples enumerateObjectsUsingBlock:^(NSDictionary *example, NSUInteger index, BOOL *stop) {
            NSString *objcName = example[@"className"];
            NSString *swiftName = [NSString stringWithFormat:@"%@_Swift", objcName];
            NSString *title = example[@"title"] ? example[@"title"] : example[@"className"];
            
            NSAssert(NSClassFromString(objcName) != nil, ([NSString stringWithFormat:@"The class %@ does not exist", objcName]));
            [objcExamples addObject:@{ @"className": objcName, @"title": title }];
            NSAssert(NSClassFromString(swiftName) != nil, ([NSString stringWithFormat:@"The class %@ does not exist", swiftName]));
            [swiftExamples addObject:@{ @"className": swiftName, @"title": title }];
        }];
        
        [objcCategories addObject:@{
            @"title": category[@"title"],
            @"examples": objcExamples
        }];
        [swiftCategories addObject:@{
            @"title": category[@"title"],
            @"examples": swiftExamples
        }];
    }];
    
    return @[
        @{@"title": @"Swift", @"categories": swiftCategories},
        @{@"title": @"Objective-C", @"categories": objcCategories}
    ];
}

@end
