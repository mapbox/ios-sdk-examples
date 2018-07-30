//
//  ClusteringWithImagesExample.m
//  Examples
//
//  Created by Joshua Erb on 7/30/18.
//  Copyright © 2018 Mapbox. All rights reserved.
//

#import "ClusteringWithImagesExample.h"
@import Mapbox;

NSString *const MBXExampleClusteringWithImages = @"ClusteringWithImagesExample";

@interface ClusteringWithImagesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UILabel *popup;

@end

@implementation ClusteringWithImagesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Light style.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                            styleURL:[MGLStyle lightStyleURL]];

}

@end
