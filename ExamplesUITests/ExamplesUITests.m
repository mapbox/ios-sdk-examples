//
//  ExamplesUITests.m
//  ExamplesUITests
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Examples.h"

@interface ExamplesUITests : XCTestCase

@end

@implementation ExamplesUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];

    for (int i = 0; i < app.tables.cells.count; i++) {
        [app.tables.cells.allElementsBoundByIndex[i] tap];

        XCUIElement *map = app.otherElements[@"Map"];
        [self waitForElementToBeHittable:map];

        [map doubleTap];
        [map twoFingerTap];

        [map rotate:M_1_PI withVelocity:1];

//        This fails because the rotate gesture doesn't fire reliably
//        XCUIElement *compass = map.images[@"Compass"];
//        [self waitForElementToBeHittable:compass];
//        [compass tap];

        [app.navigationBars.buttons[@"Examples"] tap];
    }

}

- (void)waitForElementToBeHittable:(XCUIElement *)element {
    NSPredicate *hittablePredicate = [NSPredicate predicateWithFormat:@"hittable == true"];
    [self expectationForPredicate:hittablePredicate evaluatedWithObject:element handler:nil];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            [self recordFailureWithDescription:[NSString stringWithFormat:@"%@ failed to be hittable after 1 second.", element]
                                        inFile:@__FILE__
                                        atLine:__LINE__
                                      expected:NO];
        }
    }];
}

@end
