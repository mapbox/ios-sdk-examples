//
//  AnnotationMovementExample.m
//  Examples
//
//  Created by Jason Wray on 7/19/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "AnnotationMovementExample.h"
@import Mapbox;

NSString *const MBXExampleAnnotationMovement = @"AnnotationMovementExample";

// MGLAnnotationView subclass
@interface MoveableAnnotationView : MGLAnnotationView
@end

@implementation MoveableAnnotationView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier size:(CGFloat)size {
    self = [self initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        // This property prevents the annotation from changing size when the map is tilted.
        self.scalesWithViewingDistance = false;

        // Begin setting up the view.
        self.frame = CGRectMake(0, 0, size, size);

        self.backgroundColor = [UIColor darkGrayColor];

        // Use CALayer’s corner radius to turn this view into a circle.
        self.layer.cornerRadius = size / 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
    }
    return self;
}

@end

//
// Example view controller
@interface AnnotationMovementExample () <MGLMapViewDelegate>
@end

@implementation AnnotationMovementExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.styleURL = [MGLStyle lightStyleURLWithVersion:9];
    mapView.tintColor = [UIColor darkGrayColor];
    mapView.zoomLevel = 1;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}


@end
