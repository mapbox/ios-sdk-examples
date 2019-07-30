#import "CacheManagementExample.h"
@import Mapbox;

NSString *const MBXExampleCacheManagement = @"CacheManagementExample";

@interface CacheManagementExample () <MGLMapViewDelegate>

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

    [self addOfflinePack];
    [self addButton];
}

// Create an offline pack.
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
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] invalidateAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        } else {
            CFTimeInterval difference = CACurrentMediaTime() - start;

            // Present a popup displaying how long the method took to execute.
            [self presentCompletionAlertWithTitle:@"Ambient Cache Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated ambient cache in %f seconds", difference]];
        }
    }];
}

- (void)invalidateOfflinePack {
    MGLOfflinePack *pack = [MGLOfflineStorage sharedOfflineStorage].packs.firstObject;
    CFTimeInterval start = CACurrentMediaTime();

    [[MGLOfflineStorage sharedOfflineStorage] invalidatePack:pack withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        // Present a popup displaying how long the method took to execute.
        [self presentCompletionAlertWithTitle:@"Offline Pack Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated offline pack in %f seconds", difference]];
    }];
}

// This deletes res
- (void)clearAmbientCache {
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] clearAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        // Present a popup displaying how long the method took to execute.
        [self presentCompletionAlertWithTitle:@"Ambient Cache Cleared" andMessage: [NSString stringWithFormat: @"Cleared ambient cache in %f seconds", difference]];
    }];
}

// This method deletes the cache.db file, then reinitializes it. This deletes offline packs and ambient cache resources. You should not need to call this method.
- (void)resetDatabase {
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] resetDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        // Present a popup displaying how long the method took to execute.
        [self presentCompletionAlertWithTitle:@"Database reset" andMessage: [NSString stringWithFormat: @"Reset database in %f seconds", difference]];
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

        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Invalidate Ambient Cache" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self invalidateAmbientCache];
        }]];

         [self.alertController addAction:[UIAlertAction actionWithTitle:@"Invalidate Offline Pack" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self invalidateOfflinePack];
        }]];

          [self.alertController addAction:[UIAlertAction actionWithTitle:@"Clear Ambient Cache" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self clearAmbientCache];
         }]];

           [self.alertController addAction:[UIAlertAction actionWithTitle:@"Reset Database" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self resetDatabase];
          }]];

        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }

    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)presentCompletionAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
