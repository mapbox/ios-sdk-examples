#import "LocationPrivacyExample.h"
@import Mapbox;

NSString *const MBXExampleLocationPrivacy = @"LocationPrivacyExample";

@interface LocationPrivacyExample () <MGLMapViewDelegate>
@end

@implementation LocationPrivacyExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;

    // Enable heading tracking mode so that the puck will appear.
    mapView.userTrackingMode = MGLUserTrackingModeFollow;

    [self.view addSubview:mapView];
}

/**
    In order to enable the alert that requests temporary precise location, please add the following key to your info.plist
    Privacy - Location Temporary Usage Description Dictionary

    You must then add MGLAccuracyAuthorizationDescription as key in the Privacy - Location Temporary Usage Description Dictionary
 */
- (void)mapView:(MGLMapView *)mapView didChangeLocationManagerAuthorization:(id<MGLLocationManager>)manager {
    if (@available(iOS 14, *)) {
        if (manager.accuracyAuthorization == CLAccuracyAuthorizationReducedAccuracy) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Examples will work best with your precise location"
                                                                           message:@"Please enable in settings to not receive this message again"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Turn on in Settings"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Keep Precise Location Off"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil];
            [alert addAction:settingsAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

@end
