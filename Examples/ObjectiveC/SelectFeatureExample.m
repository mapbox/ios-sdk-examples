//
//  SelectFeatureExample.m
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "SelectFeatureExample.h"
@import Mapbox;

NSString *const MBXExampleSelectFeature = @"SelectFeatureExample";

@interface SelectFeatureExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLGeoJSONSource *selectedFeaturesSource;

@end

@implementation SelectFeatureExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736)
		       zoomLevel:11
			animated:NO];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMap:)];
    tapGR.numberOfTouchesRequired = 1;
    tapGR.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:tapGR];

    mapView.delegate = self;

    [self.view addSubview:mapView];

    self.mapView = mapView;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    MGLGeoJSONSource *source = [[MGLGeoJSONSource alloc] initWithIdentifier:@"selected-features" features:@[] options:NULL];
    MGLFillStyleLayer *selectedFeaturesLayer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"selected-features" source:source];
    selectedFeaturesLayer.fillColor = [MGLStyleValue valueWithRawValue:[UIColor redColor]];

    [style addSource:source];
    [style addLayer:selectedFeaturesLayer];

    self.selectedFeaturesSource = source;
}

- (void)didTapMap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
	CGRect pointRect = {
	    [recognizer locationInView:recognizer.view],
	    CGSizeZero
	};
	CGRect touchRect = CGRectInset(pointRect, -22.0, -22.0);

	NSMutableArray *features = @[].mutableCopy;
	for (id f in [self.mapView visibleFeaturesInRect:touchRect inStyleLayersWithIdentifiers:[NSSet setWithArray:@[@"park"]]]) {
	    [features addObject:f];
	}
	self.selectedFeaturesSource.features = features;
    }
}

@end
