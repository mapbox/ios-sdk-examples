#import "CacheManagementExample.h"
@import Mapbox;

NSString *const MBXExampleCacheManagement = @"CacheManagementExample";

@interface CacheManagementExample () <MGLMapViewDelegate, UIActionSheetDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIButton *alertButton;
@property (nonatomic) UIAlertController *alertController;
@end

@implementation CacheManagementExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    [self addButton];
}

// Create an offline pack. This
- (void)addOfflinePack {
    MGLTilePyramidOfflineRegion *region = [[MGLTilePyramidOfflineRegion alloc] initWithStyleURL:self.mapView.styleURL bounds:self.mapView.visibleCoordinateBounds fromZoomLevel:0 toZoomLevel:2];

    NSDictionary *info = @{@"name": @"Offline Pack"};
    [NSKeyedArchiver archivedDataWithRootObject:info];

    [[MGLOfflineStorage sharedOfflineStorage] addPackForRegion:region withContext:info completionHandler:^(MGLOfflinePack * _Nullable pack, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }

        [pack resume];
    }];

}

#pragma mark: Cache management methods called by action sheet
- (void)invalidateAmbientCache {
    [[MGLOfflineStorage sharedOfflineStorage] invalidateAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        } else {
            [self presentCompletionAlertWithTitle:@"Ambient Cache Invalidated" andMessage:@"Invalidated ambient cache in X seconds"];
        }
    }];
}

- (void)invalidateOfflinePack {
    MGLOfflinePack *pack = [MGLOfflineStorage sharedOfflineStorage].packs.firstObject;

    [[MGLOfflineStorage sharedOfflineStorage] invalidatePack:pack withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
    }];
}

- (void)clearAmbientCache {
    [[MGLOfflineStorage sharedOfflineStorage] clearAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
    }];
}

// This method should not need to be called.
- (void)resetDatabase {
    [[MGLOfflineStorage sharedOfflineStorage] resetDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
    }];
}

# pragma mark: Add UI components
- (void)addButton {
    self.alertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.alertButton.frame = CGRectMake(0, 0, 60, 20);
    self.alertButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.alertButton.backgroundColor = [UIColor purpleColor];

    [self.view insertSubview:self.alertButton aboveSubview:self.mapView];

    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:self.alertButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.attributionButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                              ]
     ];
    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:self.alertButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]
                                              ]
     ];

    [self.alertButton addTarget:self action:@selector(presentActionSheet) forControlEvents:UIControlEventTouchUpInside];
}

- (void)presentActionSheet {

    if (!self.alertController) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"Cache Management Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *actions = @[@"Invalidate Ambient Cache", @"Invalidate Offline Pack", @"Clear Ambient Cache", @"Reset Database"];

        for (NSString *action in actions) {
            [self.alertController addAction:[UIAlertAction actionWithTitle:action style:UIAlertActionStyleDefault handler:nil]];
        }
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }

    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self invalidateAmbientCache];
            break;
        case 1:
            [self invalidateOfflinePack];
            break;
        case 2:
            [self clearAmbientCache];
            break;
        case 3:
            [self resetDatabase];
        default:
            break;
    }
}

- (void)presentCompletionAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
