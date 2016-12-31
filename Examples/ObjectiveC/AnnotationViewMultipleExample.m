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

// MGLPointAnnotation subclass
@interface MyCustomPointAnnotation : MGLPointAnnotation
@property (nonatomic, assign) BOOL willUseImage;
@end

@implementation MyCustomPointAnnotation
@end
// end MGLPointAnnotation subclass

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
    mapView.centerCoordinate = CLLocationCoordinate2DMake(48.47, -122.68);
    mapView.zoomLevel = 6;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    // Create four new point annotations with specified coordinates and titles.
    MyCustomPointAnnotation *pointA = [[MyCustomPointAnnotation alloc] init];
    pointA.title = @"Seattle";
    pointA.coordinate = CLLocationCoordinate2DMake(47.60, -122.33);
//    pointA.willUseImage = NO;
    
    MyCustomPointAnnotation *pointB = [[MyCustomPointAnnotation alloc] init];
    pointB.title = @"Vancouver";
    pointB.coordinate = CLLocationCoordinate2DMake(49.27, -123.12);
//    pointB.willUseImage = NO;
    
    MyCustomPointAnnotation *pointC = [[MyCustomPointAnnotation alloc] init];
    pointC.title = @"Olympic National Park";
    pointC.coordinate = CLLocationCoordinate2DMake(47.84, -123.54);
    pointC.willUseImage = YES;
    
    MyCustomPointAnnotation *pointD = [[MyCustomPointAnnotation alloc] init];
    pointD.title = @"North Cascades National Park";
    pointD.coordinate = CLLocationCoordinate2DMake(48.85, -121.40);
    pointD.willUseImage = YES;
    
    // Fill an array with two point annotations.
    NSArray *myPlaces = @[pointA, pointB, pointC, pointD];
    
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

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation

{
    if (annotation.willUseImage) {
        return nil;
    }

    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"tree"];
    
    if (!annotationImage)
    {
        UIImage *image = [UIImage imageNamed:@"tree"];
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"tree"];
    }
    
    return annotationImage;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
}

@end
