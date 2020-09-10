#import "LocationPrivacyExample.h"
@import Mapbox;

NSString *const MBXExampleLocationPrivacy = @"LocationPrivacyExample";

@interface LocationPrivacyExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIButton *preciseButton;
@end

@implementation LocationPrivacyExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    self.mapView = mapView;

    [self.view addSubview:mapView];
}

/**
    In order to enable the alert that requests temporary precise location,
    please add the following key to your info.plist
    @c NSLocationTemporaryUsageDescriptionDictionary

    You must then add
    @c MGLAccuracyAuthorizationDescription
    as a key in the Privacy - Location Temporary Usage Description Dictionary
 */
- (void)mapView:(MGLMapView *)mapView didChangeLocationManagerAuthorization:(id<MGLLocationManager>)manager {
    if (@available(iOS 14, *)) {
        if (manager.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
            [self addPreciseButton];
        } else {
            [self removePreciseButton];
        }
    }
}

- (void)addPreciseButton {
    UIButton *preciseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preciseButton setTitle:@"Turn Precise On" forState:UIControlStateNormal];
    preciseButton.backgroundColor = UIColor.grayColor;

    [preciseButton addTarget:self action:@selector(requestTemporaryAuth) forControlEvents:UIControlEventTouchDown];
    self.preciseButton = preciseButton;
    [self.view addSubview:preciseButton];

    // constraints
    [preciseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [preciseButton.widthAnchor constraintEqualToConstant:150.0].active = YES;
    [preciseButton.heightAnchor constraintEqualToConstant:40.0].active = YES;
    [preciseButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100.0].active = YES;
    [preciseButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
}

- (void)requestTemporaryAuth {
    if (self.mapView != nil) {
        NSString *purposeKey = @"Examples needs your precise location to accurately show user location";
        if (@available(iOS 14, *)) {
            [self.mapView.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:purposeKey];
        }
    }
}

- (void)removePreciseButton {
    if (self.preciseButton != nil) {
        [self.preciseButton removeFromSuperview];
        self.preciseButton = nil;
    }
}

@end
