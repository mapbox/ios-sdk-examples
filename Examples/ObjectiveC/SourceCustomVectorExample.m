//
//  SourceCustomVectorExample.m
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SourceCustomVectorExample.h"
@import Mapbox;

NSString *const MBXExampleSourceCustomVector = @"SourceCustomVectorExample";

@implementation SourceCustomVectorExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[[NSBundle mainBundle] URLForResource:@"third_party_vector_style" withExtension:@"json"]];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:mapView];
}

@end
