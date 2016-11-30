//
//  RuntimeCircleStylesExample.m
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "RuntimeCircleStylesExample.h"
@import Mapbox;

NSString *const MBXExampleRuntimeCircleStyles = @"RuntimeCircleStylesExample";

@interface RuntimeCircleStylesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation RuntimeCircleStylesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setStyleURL:[MGLStyle lightStyleURLWithVersion:9]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map's center coordinate
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.753574, -122.447303)
			    zoomLevel:10
			     animated:NO];

    [self.view addSubview:self.mapView];

    // Set the delegate property of our map view to self after instantiating it
    self.mapView.delegate = self;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self addLayer];
}

- (void)addLayer {
    MGLSource *source = [[MGLVectorSource alloc] initWithIdentifier:@"population" URL:[NSURL URLWithString:@"mapbox://examples.8fgz4egr"]];

    NSDictionary *ethnicities = @{
	@"White": [UIColor colorWithRed: 251/255.0 green: 176/255.0 blue: 59/255.0 alpha: 1.0],
	@"Black": [UIColor colorWithRed: 34/255.0 green: 59/255.0 blue: 83/255.0 alpha: 1.0],
	@"Hispanic": [UIColor colorWithRed: 229/255.0 green: 94/255.0 blue: 94/255.0 alpha: 1.0],
	@"Asian": [UIColor colorWithRed: 59/255.0 green: 178/255.0 blue: 208/255.0 alpha: 1.0],
	@"Other": [UIColor colorWithRed: 204/255.0 green: 204/255.0 blue: 204/255.0 alpha: 1.0],
    };


    [self.mapView.style addSource:source];

    for (NSString *key in [ethnicities allKeys]) {
	MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"population-%@", key] source:source];
	layer.sourceLayerIdentifier = @"sf2010";
	layer.circleRadius = [MGLStyleValue valueWithBase:1.75 stops:@{
	    @12: [MGLStyleValue valueWithRawValue:@2],
	    @22: [MGLStyleValue valueWithRawValue:@180]
	}];
	layer.circleOpacity = [MGLStyleValue valueWithRawValue:@0.7];
	layer.circleColor = [MGLStyleValue valueWithRawValue:ethnicities[key]];
	layer.predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"ethnicity", key];

	[self.mapView.style addLayer:layer];
    }
}

@end
