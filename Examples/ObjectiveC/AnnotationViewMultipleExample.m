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
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
        styleURL:[MGLStyle lightStyleURLWithVersion:9]];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    mapView.centerCoordinate = CLLocationCoordinate2DMake(39.83, -98.58);
    
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    NSDictionary *pointA = @{
        @"location" : [[CLLocation alloc] initWithLatitude: 37.79 longitude: -122.43],
        @"title" : @"San Francisco"
    };
    
    NSDictionary *pointB = @{
        @"location" : [[CLLocation alloc] initWithLatitude: 38.90 longitude: -77.04],
        @"title" : @"Washington, D.C"
    };
    
    NSArray *locations = @[pointA, pointB];
    
    NSMutableArray *pointAnnotations = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in locations) {
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        point.coordinate = ((CLLocation *)item[@"location"]).coordinate;
        point.title = item[@"title"];
        [pointAnnotations addObject:point];
    }
    
    [mapView addAnnotations:pointAnnotations];
}

// This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }
    
    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];
    
    // For better performance, always try to reuse existing annotations.
    MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.frame = CGRectMake(0, 0, 30, 30);
        annotationView.layer.cornerRadius = annotationView.frame.size.width / 2;
        annotationView.layer.borderColor = [UIColor whiteColor].CGColor;
        annotationView.layer.borderWidth = 4.0;
        
        
        // Set the annotation view’s background color to a value determined by its longitude.
        CGFloat hue = arc4random_uniform(101) / 100.0;
        
        annotationView.backgroundColor = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    }
    
    return annotationView;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

@end
