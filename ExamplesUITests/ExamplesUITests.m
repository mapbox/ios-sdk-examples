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

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    app.launchArguments = [app.launchArguments arrayByAddingObject:@"useFastAnimations"];
    [app launch];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAnimatedLineExample {

    [XCTContext runActivityNamed:@"AnimatedLineExample"
                           block:^(id<XCTActivity>  _Nonnull activity) {

                               XCUIApplication *app = [[XCUIApplication alloc] init];
                               [app.tables.staticTexts[@"AnimatedLineExample"] tap];

                               // Wait for notification
                               XCTDarwinNotificationExpectation *expectation = [[XCTDarwinNotificationExpectation alloc] initWithNotificationName:@"com.mapbox.examples.example-complete"];

                               [self waitForExpectations:@[expectation] timeout:30.0];

                               [app.navigationBars[@"AnimatedLineExample"].buttons[@"Examples"] tap];
                           }];
}

- (void)testEveryExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];

    __block NSUInteger count;
    __block NSMutableArray<XCUIElement*> *elements;
    __block NSMutableArray<NSString*> *titles;

    // Build arrays of the examples (so the report can be broken into readable
    // activities)
    [XCTContext runActivityNamed:@"Get examples"
                           block:^(id<XCTActivity>  _Nonnull activity) {

                               XCUIElementQuery *cells = app.tables.cells;
                               count = cells.count;

                               elements = [NSMutableArray arrayWithCapacity:count];
                               titles = [NSMutableArray arrayWithCapacity:count];

                               for (int i = 0; i < count; i++) {
                                   XCUIElement *el = cells.allElementsBoundByIndex[i];
                                   NSString *title = [[el.staticTexts element] label];

                                   [elements addObject:el];
                                   [titles addObject:title];
                               }
                           }];

    for (NSUInteger i = 0; i < count; i++) {
        [XCTContext runActivityNamed:titles[i]
                               block:^(id<XCTActivity>  _Nonnull activity) {
            [elements[i] tap];
                                   
            // XCTest waits for the app to idle before continuing.

           // Tap 'Back' button.
           [app.navigationBars.buttons.allElementsBoundByIndex.firstObject tap];
        }];
    }
}

@end
