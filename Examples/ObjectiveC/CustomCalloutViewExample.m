//
//  CustomCalloutViewExample.m
//  Examples
//
//  Created by Jason Wray on 3/6/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CustomCalloutViewExample.h"
#import "CustomCalloutView.h"
@import Mapbox;

NSString *const MBXExampleCustomCalloutView = @"CustomCalloutViewExample";

@interface CustomCalloutViewExample () <MGLMapViewDelegate>

@end

@implementation CustomCalloutViewExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mapView];

    // Set the map view‘s delegate property
    mapView.delegate = self;

    // Initialize and add the marker annotation
    MGLPointAnnotation *marker = [[MGLPointAnnotation alloc] init];
    marker.coordinate = CLLocationCoordinate2DMake(0, 0);
    marker.title = @"Hello world!";
    marker.subtitle = @"Welcome to my marker";

    // Add marker to the map
    [mapView addAnnotation:marker];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped
    return YES;
}

- (UIView<MGLCalloutView> *)mapView:(__unused MGLMapView *)mapView calloutViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if ([annotation respondsToSelector:@selector(title)]
        && [annotation.title isEqualToString:@"Hello world!"])
    {
        CustomCalloutView *calloutView = [[CustomCalloutView alloc] init];
        calloutView.representedObject = annotation;
        return calloutView;
    }
    return nil;
}

- (void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation
{
    NSLog(@"Tapped the callout for: %@", annotation);
}

@end
