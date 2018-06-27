//
//  ExamplesUITests.m
//  ExamplesUITests
//
//  Created by Jason Wray on 1/26/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Examples.h"
#import "TestingSupport.h"

@interface ExamplesUITests : XCTestCase
@property (nonatomic) XCUIApplication *app;
@end

@implementation ExamplesUITests

- (void)setUp {
    [super setUp];

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
    self.app.launchArguments = [self.app.launchArguments arrayByAddingObject:@"useFastAnimations"];
    [self.app launch];

    [self.app.navigationBars[@"Examples"].buttons[@"ObjC"] tap];
}

- (void)tearDown {
    [super tearDown];
}

/**
 testAnimatedLineExample
 Wait for the line to be fully animated
 */
- (void)testAnimatedLineExample {

    [XCTContext runActivityNamed:@"AnimatedLineExample" block:^(id<XCTActivity>  _Nonnull activity) {
        [self.app.tables.staticTexts[@"Animate a line"] tap];

        // Wait for notification
        XCTDarwinNotificationExpectation *expectation = [[XCTDarwinNotificationExpectation alloc] initWithNotificationName:MBXTestingSupportNotificationExampleComplete];
        [self waitForExpectations:@[expectation] timeout:30.0];

        [self.app.navigationBars[@"AnimatedLineExample"].buttons[@"Examples"] tap];
    }];
}

/**
 testCustomAnnotationView
 Zoom and rotate the map.
 */
- (void)testCustomAnnotationView {

    __block XCUIElement *element;
    __block XCUIElement *compass;

    [XCTContext runActivityNamed:@"Wait for initial render" block:^(id<XCTActivity>  _Nonnull activity) {
        [self.app.tables.staticTexts[@"Annotation views"] tap];
        XCUIElementQuery *allQuery = [self.app descendantsMatchingType:XCUIElementTypeAny];
        element = [allQuery elementMatchingType:XCUIElementTypeAny identifier:@"MGLMapViewId"];
        compass = [allQuery elementMatchingType:XCUIElementTypeAny identifier:@"MGLMapViewCompassId"];

        XCTDarwinNotificationExpectation *expectation = [[XCTDarwinNotificationExpectation alloc] initWithNotificationName:MBXTestingSupportNotificationMapViewRendered];
        [self waitForExpectations:@[expectation] timeout:10.0];
    }];

    [XCTContext runActivityNamed:@"Pinch & Rotate" block:^(id<XCTActivity>  _Nonnull activity) {
        [element pinchWithScale:3 velocity:10.0];
        [element rotate:M_PI*0.75 withVelocity:M_PI*0.75]; // should take 1 second
        [element pinchWithScale:0.2 velocity:-10.0];

        [compass tap];

        [element pinchWithScale:0.2 velocity:-10.0];
    }];

    // TODO: Check orientation & shape of annotations.

    // Wait, just so we can see something
    [XCTContext runActivityNamed:@"Wait" block:^(id<XCTActivity>  _Nonnull activity) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
        (void)[XCTWaiter waitForExpectations:@[expectation] timeout:3.0]; // Let it timeout

        [self.app.navigationBars[@"AnnotationViewExample"].buttons[@"Examples"] tap];
    }];
}

- (void)testBuildingLightExample {
    __block XCUIElement *element;
    __block XCUIElement *slider;

    [XCTContext runActivityNamed:@"Wait for initial render" block:^(id<XCTActivity>  _Nonnull activity) {
        [self.app.tables.staticTexts[@"Adjust lighting of 3D buildings"] tap];
        XCUIElementQuery *allQuery = [self.app descendantsMatchingType:XCUIElementTypeAny];
        element = [allQuery elementMatchingType:XCUIElementTypeAny identifier:@"MGLMapViewId"];
        slider = [allQuery elementMatchingType:XCUIElementTypeSlider identifier:@"SliderId"];

        XCTDarwinNotificationExpectation *expectation = [[XCTDarwinNotificationExpectation alloc] initWithNotificationName:MBXTestingSupportNotificationMapViewRendered];
        [self waitForExpectations:@[expectation] timeout:10.0];
    }];

    [XCTContext runActivityNamed:@"Adjust light" block:^(id<XCTActivity>  _Nonnull activity) {
        [slider adjustToNormalizedSliderPosition:0.0];
        [slider adjustToNormalizedSliderPosition:1.0];
        [slider adjustToNormalizedSliderPosition:0.5];
    }];

    [self.app.navigationBars[@"BuildingLightExample"].buttons[@"Examples"] tap];
}


- (void)testEveryExample {

    __block NSUInteger count;
    __block NSMutableArray<XCUIElement*> *elements;
    __block NSMutableArray<NSString*> *titles;

    // Build arrays of the examples (so the report can be broken into readable
    // activities)
    [XCTContext runActivityNamed:@"Get examples" block:^(id<XCTActivity>  _Nonnull activity) {

        XCUIElementQuery *cells = self.app.tables.cells;
        count = cells.count;

        elements = [NSMutableArray arrayWithCapacity:count];
        titles = [NSMutableArray arrayWithCapacity:count];

        for (int i = 0; i < count; i++) {
            XCUIElement *el = cells.allElementsBoundByIndex[i];
            NSString *title = [[el.staticTexts element].firstMatch label];

            [elements addObject:el];
            [titles addObject:title];
        }
    }];

    for (NSUInteger i = 0; i < count; i++) {
        [XCTContext runActivityNamed:titles[i] block:^(id<XCTActivity>  _Nonnull activity) {
            [elements[i] tap];

            // XCTest waits for the app to idle before continuing.

            // Tap 'Back' button.
            [self.app.navigationBars.buttons.allElementsBoundByIndex.firstObject tap];
        }];
    }
}

@end
