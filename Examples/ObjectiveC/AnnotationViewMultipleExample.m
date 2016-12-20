//
//  AnnotationViewMultipleExample.m
//  Examples
//
//  Created by Nadia Barbosa on 12/13/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "AnnotationViewMultipleExample.h"
@import Mapbox;

NSString *const MBXExampleAnnotationViewMultiple = @"AnnotationViewMultipleExample";

@interface AnnotationViewMultipleExample () <MGLMapViewDelegate>

@end

@implementation AnnotationViewMultipleExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Light style.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
        styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's center coordinate and zoom level.
    mapView.centerCoordinate = CLLocationCoordinate2DMake(39.83, -98.58);
    mapView.zoomLevel = 2;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    // Create two new point annotations with specified coordinates and titles.
    MGLPointAnnotation *pointA = [[MGLPointAnnotation alloc] init];
    pointA.title = @"San Francisco";
    pointA.coordinate = CLLocationCoordinate2DMake(37.79, -122.43);
    
    MGLPointAnnotation *pointB = [[MGLPointAnnotation alloc] init];
    pointB.title = @"Washington, D.C.";
    pointB.coordinate = CLLocationCoordinate2DMake(38.90, -77.04);
    
    // Fill an array with two point annotations.
    NSArray *myPlaces = @[pointA, pointB];
    
    // Add all annotations to the map all at once, instead of individually.
    [mapView addAnnotations:myPlaces];
}

// This delegate method is where you tell the map to load a view for a specific annotation.
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
    NSString *reuseIdentifier = @"reusableDotView";
    
    // For better performance, always try to reuse existing annotations.
    MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.frame = CGRectMake(0, 0, 30, 30);
        annotationView.layer.cornerRadius = annotationView.frame.size.width / 2;
        annotationView.layer.borderColor = [UIColor whiteColor].CGColor;
        annotationView.layer.borderWidth = 4.0;
    }
    
    // Generate a random number between 0 and 1 to be used as the hue for the annotation view.
    CGFloat hue = arc4random_uniform(101) / 100.0;
    annotationView.backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    
    return annotationView;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
}

@end
