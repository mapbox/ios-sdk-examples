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

    if ( ! [MGLAccountManager accessToken]) {
        NSString *accessToken = [[NSProcessInfo processInfo] environment][@"MAPBOX_ACCESS_TOKEN"];
        if (accessToken) {
            // Store to preferences so that we can launch the app later on without having to specify
            // token.
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:MBXMapboxAccessTokenDefaultsKey];
        } else {
            // Try to retrieve from preferences, maybe we've stored them there previously and can reuse
            // the token.
            accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:MBXMapboxAccessTokenDefaultsKey];
        }
        [MGLAccountManager setAccessToken:accessToken];
    }

    return YES;
}

@end
