//
//  CustomAnnotationModelExample.m
//  Examples
//
//  Created by Jason Wray on 5/20/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CustomAnnotationModelExample.h"
#import "CustomAnnotationModels.h"
@import Mapbox;

NSString *const MBXExampleCustomAnnotationModel = @"CustomAnnotationModelExample";

@interface CustomAnnotationModelExample () <MGLMapViewDelegate>

@end

@implementation CustomAnnotationModelExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.styleURL = [MGLStyle lightStyleURLWithVersion:9];
    mapView.tintColor = [UIColor darkGrayColor];
    mapView.zoomLevel = 1;
    mapView.delegate = self;
    [self.view addSubview:mapView];

    // Point Annotation
    CustomPointAnnotation *point = [[CustomPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(0, 0);
    point.title = @"Custom Point Annotation";
    // Set the custom `image` and `reuseIdentifier` properties, later used in the `mapView:imageForAnnotation:` delegate method.
    point.image = [self dotWithSize:20];
    point.reuseIdentifier = @"yeOldeGreyDot";

    // Polyline
    // Create a coordinates array with all of the coordinates for our polyline.
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(35, -25),
        CLLocationCoordinate2DMake(20, -30),
        CLLocationCoordinate2DMake( 0, -25),
        CLLocationCoordinate2DMake(-15,  0),
        CLLocationCoordinate2DMake(-45, 10),
        CLLocationCoordinate2DMake(-45, 40),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);

    CustomPolyline *polyline = [CustomPolyline polylineWithCoordinates:coordinates count:numberOfCoordinates];//
    // Set the custom `color` property, later used in the `mapView:strokeColorForShapeAnnotation:` delegate method.
    polyline.color = [UIColor darkGrayColor];

    // Add both annotations to the map.
    [mapView addAnnotations:@[point, polyline]];
}

- (UIImage *)dotWithSize:(CGFloat)size {
    CGRect rect = CGRectMake(0, 0, size, size);
    CGFloat strokeWidth = 1;

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);

    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, strokeWidth, strokeWidth)];
    [UIColor.darkGrayColor setFill];
    [ovalPath fill];

    [UIColor.whiteColor setStroke];
    ovalPath.lineWidth = strokeWidth;
    [ovalPath stroke];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - MGLMapViewDelegate methods

-(MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
        CustomPointAnnotation *point = (CustomPointAnnotation *)annotation;
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:point.reuseIdentifier];

        if (annotationImage) {
            // The annotatation image has already been cached, just reuse it.
            return annotationImage;
        } else if (point.image && point.reuseIdentifier) {
            // Create a new annotation image.
            return [MGLAnnotationImage annotationImageWithImage:point.image reuseIdentifier:point.reuseIdentifier];
        }
    }

    // Fallback to the default marker image.
    return nil;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    if ([annotation isKindOfClass:[CustomPolyline class]]) {
        // Return orange if the polyline does not have a custom color.
        return [(CustomPolyline *)annotation color] ?: [UIColor orangeColor];
    }

    // Fallback to the default tint color.
    return mapView.tintColor;
}

-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

@end
