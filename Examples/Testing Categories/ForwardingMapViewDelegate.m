#import "ForwardingMapViewDelegate.h"
#import "TestingSupport.h"
#import <objc/runtime.h>

static void * forwardingMapViewAssociationStaticKey = &forwardingMapViewAssociationStaticKey;

@implementation ForwardingMapViewDelegate

+ (void)addToMapView:(MGLMapView*)mapView {
    ForwardingMapViewDelegate *forwarder = [[ForwardingMapViewDelegate alloc] init];
    forwarder.delegate = mapView.delegate;
    mapView.delegate = forwarder;

    objc_setAssociatedObject(mapView, forwardingMapViewAssociationStaticKey, forwarder, OBJC_ASSOCIATION_RETAIN);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.delegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self.delegate];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {

    static NSMutableDictionary *rts = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rts = [NSMutableDictionary dictionary];
    });

    NSString *selectorName = NSStringFromSelector(aSelector);

    NSNumber *rtsNumber = rts[selectorName];

    if (rtsNumber) {
        return [rtsNumber boolValue];
    }

    BOOL responds = ([super respondsToSelector:aSelector] ||
                     [self.delegate respondsToSelector:aSelector]);

    rts[selectorName] = @(responds);

    return responds;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [self.delegate methodSignatureForSelector:selector];
    }
    return signature;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate mapView:mapView didFinishLoadingStyle:style];
    }

    testingSupportPostNotification(MBXTestingSupportNotificationMapViewStyleLoaded);
}

- (void)mapViewDidFinishRenderingMap:(MGLMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate mapViewDidFinishRenderingMap:mapView fullyRendered:fullyRendered];
    }

    testingSupportPostNotification(MBXTestingSupportNotificationMapViewRendered);
}

@end
