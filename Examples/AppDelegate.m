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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Speed-up Core Animation-based animations in testing scenarios.
    if ([[NSProcessInfo processInfo].arguments containsObject:@"useFastAnimations"]) {
        self.window.layer.speed = 100;
    }

    // Read APIKeys.plist; see APIKeys.EXAMPLE.plist for the format.
    NSDictionary *apiKeys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"APIKeys" ofType:@"plist"]];
    NSString *mapboxAccessToken = [apiKeys objectForKey:@"MGLMapboxAccessToken"];
    NSAssert(mapboxAccessToken, @"REQUIRED: Mapbox access token must be set in APIKeys.plist");
    [MGLAccountManager setAccessToken:mapboxAccessToken];

    return YES;
}

@end
