//
//  DrawingAMarkerExample.m
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "DrawingAMarkerExample.h"
@import Mapbox;

NSString *const MBXExampleDrawingAMarker = @"DrawingAMarkerExample";

@interface DrawingAMarkerExample () <MGLMapViewDelegate>

@end

@implementation DrawingAMarkerExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's center coordinates and zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.7326808, -73.9843407)
                            zoomLevel:12
                             animated:NO];
    
    [self.view addSubview:mapView];
    
    // Set the delegate property of our map view to self after instantiating it.
    mapView.delegate = self;

    // Declare the marker `hello` and set its coordinates, title, and subtitle
    MGLPointAnnotation *hello = [[MGLPointAnnotation alloc] init];
    hello.coordinate = CLLocationCoordinate2DMake(40.7326808, -73.9843407);
    hello.title = @"Hello world!";
    hello.subtitle = @"Welcome to my marker";

    // Add marker `hello` to the map
    [mapView addAnnotation:hello];
}

// Use the default marker; see our custom marker example for more information
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    return nil;
}

// Allow markers callouts to show when tapped
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

@end
