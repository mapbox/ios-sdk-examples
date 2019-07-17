//
//  AppDelegate.m
//  Examples
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "AppDelegate.h"
@import Mapbox;

@interface AppDelegate ()

@end
@implementation AppDelegate
NSString * const MBXMapboxAccessTokenDefaultsKey = @"MBXMapboxAccessToken";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Speed-up Core Animation-based animations in testing scenarios.
    if ([[NSProcessInfo processInfo].arguments containsObject:@"useFastAnimations"]) {
        self.window.layer.speed = 100;
    }

    NSUInteger maxCacheSize = 62914560;
    [[MGLOfflineStorage sharedOfflineStorage] setMaximumAmbientCacheSize:maxCacheSize withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to set maximum ambient cache size");
        }
    }];

    return YES;
}

@end
