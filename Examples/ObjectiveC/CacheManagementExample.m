#import "CacheManagementExample.h"
@import Mapbox;

NSString *const MBXExampleCacheManagement = @"CacheManagementExample";

@interface CacheManagementExample ()
@property (nonatomic) MGLMapView *mapView;
@end

@implementation CacheManagementExample

- (void)viewDidLoad {
    [super viewDidLoad];

    /* Set the maximum ambient cache size in bytes. Call this method before the map view is loaded.

     The ambient cache is created through the end user loading and using a map view. */
    NSUInteger maximumCacheSizeInBytes = 64 * 1024 * 1024;

    [[MGLOfflineStorage sharedOfflineStorage] setMaximumAmbientCacheSize:maximumCacheSizeInBytes withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to set maximum ambient cache size: %@", error.localizedDescription);
        }

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupMapView];

            // Create an offline pack.
            [weakSelf addOfflinePack];
        });
    }];

    // Add a bar button. Tapping this button will present a menu of options. For this example, the cache is managed through the UI. It can also be managed by developers through remote notifications.
    // For more information about managing remote notifications in your iOS app, see the Apple "UserNotifications" documentation: https://developer.apple.com/documentation/usernotifications?language=objc
    UIBarButtonItem *alertButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(presentActionSheet)];
    [self.parentViewController.navigationItem setRightBarButtonItem:alertButton];
}

- (void)setupMapView {
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:self.mapView];
}

#pragma mark Cache management methods called by action sheet

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
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentCompletionAlertWithTitle:@"Ambient Cache Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated ambient cache in %f seconds", difference]];
            });
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

        // Display an alert to indicate that the invalidation is complete.
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentCompletionAlertWithTitle:@"Offline Pack Invalidated" andMessage: [NSString stringWithFormat: @"Invalidated offline pack in %f seconds", difference]];
        });
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
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentCompletionAlertWithTitle:@"Ambient Cache Cleared" andMessage: [NSString stringWithFormat: @"Cleared ambient cache in %f seconds", difference]];
        });
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
         __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentCompletionAlertWithTitle:@"Database reset" andMessage: [NSString stringWithFormat: @"Reset database in %f seconds", difference]];
        });
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

# pragma mark Add UI components
- (void)presentActionSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cache Management Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Invalidate Ambient Cache" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self invalidateAmbientCache];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Invalidate Offline Pack" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self invalidateOfflinePack];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Clear Ambient Cache" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearAmbientCache];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Reset Database" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self resetDatabase];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    alertController.popoverPresentationController.sourceView = self.mapView;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentCompletionAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
