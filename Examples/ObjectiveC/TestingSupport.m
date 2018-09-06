#import "TestingSupport.h"

const MBXTestingSupportNotification MBXTestingSupportNotificationExampleComplete = @"com.mapbox.examples.example-complete";
const MBXTestingSupportNotification MBXTestingSupportNotificationMapViewStyleLoaded = @"com.mapbox.examples.mapview-style-loaded";
const MBXTestingSupportNotification MBXTestingSupportNotificationMapViewRendered = @"com.mapbox.examples.mapview-rendered";

void testingSupportPostNotification(MBXTestingSupportNotification name) {
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (CFNotificationName)name, NULL, NULL, true);
}
