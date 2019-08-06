#import "CacheManagementExample.h"
@import Mapbox;

NSString *const MBXExampleCacheManagement = @"CacheManagementExample";

@interface CacheManagementExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIAlertController *alertController;
@end

@implementation CacheManagementExample

- (void)viewDidLoad {
    [super viewDidLoad];

    /* Set the maximum ambient cache size in bytes. Call this method before the map view is loaded.

     The ambient cache is created through the end user loading and using a map view. */
    NSUInteger maxCacheSize = 62914560;
    [[MGLOfflineStorage sharedOfflineStorage] setMaximumAmbientCacheSize:maxCacheSize withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to set maximum ambient cache size: %@", error.localizedDescription);
        }

        self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.mapView.delegate = self;

        [self.view addSubview:self.mapView];

        // Create an offline pack.
        [self addOfflinePack];
    }];

    // Add a bar button. Tapping this button will present a menu of options. For this example, the cache is managed through the UI. It can also be managed by developers through remote notifications.
    // For more information about managing remote notifications in your iOS app, see the Apple "UserNotifications" documentation: https://developer.apple.com/documentation/usernotifications?language=objc
    UIBarButtonItem *alertButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(presentActionSheet)];
        [self.parentViewController.navigationItem setRightBarButtonItem:alertButton];
}

#pragma mark: Cache management methods called by action sheet

// Check whether the tiles locally cached match those on the tile server. If the local tiles are out-of-date, they will be updated. Invalidating the ambient cache is preferred to clearing the cache. Tiles shared with offline packs will not be affected by this method.
- (void)invalidateAmbientCache {
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] invalidateAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        } else {
            CFTimeInterval difference = CACurrentMediaTime() - start;

            // Display an alert to indicate that the invalidation is complete.
            [self presentCompletionAlertWithTitle:@"Ambient Cache Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated ambient cache in %f seconds", difference]];
        }
    }];
}

// Check whether the local offline tiles match those on the tile server. If the local tiles are out-of-date, they will be updated. Invalidating an offline pack is preferred to removing and reinstalling the pack.
- (void)invalidateOfflinePack {
    MGLOfflinePack *pack = [MGLOfflineStorage sharedOfflineStorage].packs.firstObject;
    CFTimeInterval start = CACurrentMediaTime();

    [[MGLOfflineStorage sharedOfflineStorage] invalidatePack:pack withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        /// Display an alert to indicate that the invalidation is complete.
        [self presentCompletionAlertWithTitle:@"Offline Pack Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated offline pack in %f seconds", difference]];
    }];
}

// This removes resources from the ambient cache. Resources which overlap with offline packs will not be impacted.
- (void)clearAmbientCache {
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] clearAmbientCacheWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        // Display an alert to indicate that the deletion is complete.
        [self presentCompletionAlertWithTitle:@"Ambient Cache Cleared" andMessage: [NSString stringWithFormat: @"Cleared ambient cache in %f seconds", difference]];
    }];
}

// This method deletes the cache.db file, then reinitializes it. This deletes offline packs and ambient cache resources. You should not need to call this method. Invalidating the ambient cache and/or offline packs should be sufficient for most use cases.
- (void)resetDatabase {
    CFTimeInterval start = CACurrentMediaTime();
    [[MGLOfflineStorage sharedOfflineStorage] resetDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        CFTimeInterval difference = CACurrentMediaTime() - start;

        // Display an alert to indicate that the cache.db file has been reset.
        [self presentCompletionAlertWithTitle:@"Database reset" andMessage: [NSString stringWithFormat: @"Reset database in %f seconds", difference]];
    }];
}

- (void)addOfflinePack {
    MGLTilePyramidOfflineRegion *region = [[MGLTilePyramidOfflineRegion alloc] initWithStyleURL:self.mapView.styleURL bounds:self.mapView.visibleCoordinateBounds fromZoomLevel:0 toZoomLevel:2];

    NSDictionary *info = @{@"name": @"Offline Pack"};
    NSData *context = [NSKeyedArchiver archivedDataWithRootObject:info];

    [[MGLOfflineStorage sharedOfflineStorage] addPackForRegion:region withContext:context completionHandler:^(MGLOfflinePack * _Nullable pack, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }

        [pack resume];
    }];

}
# pragma mark: Add UI components
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
    self.alertController.popoverPresentationController.sourceView = self.mapView;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)presentCompletionAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
