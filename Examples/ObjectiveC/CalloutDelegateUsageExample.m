//
//  CalloutDelegateUsageExample.m
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CalloutDelegateUsageExample.h"
#import <Mapbox/Mapbox.h>

NSString *const MBXExampleCalloutDelegateUsage = @"CalloutDelegateUsageExample";

@interface CalloutDelegateUsageExample () <MGLMapViewDelegate>

@property MGLMapView *mapView;

@end

@implementation CalloutDelegateUsageExample

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];

    // remember to set the delegate (or much of this will not work)
    self.mapView.delegate = self;

    [self addAnnotation];
}

- (void)addAnnotation
{
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(35.03946, 135.72956);
    annotation.title = @"Kinkaku-ji";
    annotation.subtitle = [NSString stringWithFormat:@"%.5f, %.5f", annotation.coordinate.latitude, annotation.coordinate.longitude];

    [self.mapView addAnnotation:annotation];

    // fit the map to the annotation(s)
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];

    // pop-up the callout view
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return true;
}

- (UIView *)mapView:(MGLMapView *)mapView leftCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"Kinkaku-ji"])
    {
        // callout height is fixed; width expands to fit
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.f, 50.f)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithRed:0.81f green:0.71f blue:0.23f alpha:1.f];
        label.text = @"金閣寺";

        return label;
    }

    return nil;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control
{
    // hide the callout view
    [self.mapView deselectAnnotation:annotation animated:NO];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:annotation.title
                                                    message:@"A lovely (if touristy) place."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
