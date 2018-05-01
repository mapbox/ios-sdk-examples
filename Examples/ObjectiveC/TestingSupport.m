#import "TestingSupport.h"

NSString * const testingSupportExampleCompleteNotificationName = @"com.mapbox.examples.example-complete";

void testingSupportPostExampleCompleteNotification(void) {
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (CFNotificationName)testingSupportExampleCompleteNotificationName, NULL, NULL, true);
}
