@import Foundation;
@import Mapbox;

NS_ASSUME_NONNULL_BEGIN

@interface ForwardingMapViewDelegate: NSObject <MGLMapViewDelegate>
@property (nonatomic, weak, nullable) NSObject<MGLMapViewDelegate> *delegate;
+ (void)addToMapView:(MGLMapView*)mapView;
@end

NS_ASSUME_NONNULL_END
