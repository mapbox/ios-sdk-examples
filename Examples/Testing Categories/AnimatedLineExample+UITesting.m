@import Foundation;
@import Mapbox;

#import "TestingSupport.h"
#import "ForwardingMapViewDelegate.h"
#import "AnimatedLineExample.h"

static void *currentIndexObservationContext = &currentIndexObservationContext;

@interface AnimatedLineExample (AnimatedLineExample_UITesting)
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) NSArray<CLLocation *> *locations;
@end

@implementation AnimatedLineExample (AnimatedLineExample_UITesting)
@dynamic currentIndex;
@dynamic mapView;
@dynamic locations;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupForTesting];
}

- (void)setupForTesting {
    [ForwardingMapViewDelegate addToMapView:self.mapView];

    [self addObserver:self
           forKeyPath:@"currentIndex"
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
              context:currentIndexObservationContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ((context == currentIndexObservationContext) &&
        (self.currentIndex > self.locations.count)) {
        [self removeObserver:self forKeyPath:@"currentIndex"];

        testingSupportPostNotification(MBXTestingSupportNotificationExampleComplete);
    }
}

@end
