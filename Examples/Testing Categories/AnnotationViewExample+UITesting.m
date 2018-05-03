@import Foundation;
@import Mapbox;

#import "TestingSupport.h"
#import "ForwardingMapViewDelegate.h"
#import "AnnotationViewExample.h"

@interface AnnotationViewExample (UITesting)
@end

@implementation AnnotationViewExample (UITesting)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupForTesting];
}

- (void)setupForTesting {

    MGLMapView* mapView;

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[MGLMapView class]]) {
            mapView = (MGLMapView*)view;
            break;
        }
    }

    assert(mapView);

    // For UI Testing
    mapView.isAccessibilityElement = NO;
    mapView.accessibilityIdentifier = @"MGLMapViewId";
    mapView.compassView.isAccessibilityElement = NO;
    mapView.compassView.accessibilityIdentifier = @"MGLMapViewCompassId";

    [ForwardingMapViewDelegate addToMapView:mapView];
}


@end
