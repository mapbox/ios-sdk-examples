@import Foundation;
@import Mapbox;

#import "TestingSupport.h"
#import "ForwardingMapViewDelegate.h"
#import "BuildingLightExample.h"

@interface BuildingLightExample (UITesting)
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UISlider *slider;
@end

@implementation BuildingLightExample (UITesting)
@dynamic mapView;
@dynamic slider;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupForTesting];
}

- (void)setupForTesting {
    // For UI Testing
    self.mapView.isAccessibilityElement = NO;
    self.mapView.accessibilityIdentifier = @"MGLMapViewId";

    // For UI testing
    self.slider.isAccessibilityElement = NO;
    self.slider.accessibilityIdentifier = @"SliderId";

    [ForwardingMapViewDelegate addToMapView:self.mapView];
}
@end

