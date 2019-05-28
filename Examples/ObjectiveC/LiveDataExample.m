
#import "LiveDataExample.h"
@import Mapbox;

NSString *const MBXExampleLiveData = @"LiveDataExample";

@interface LiveDataExample () <MGLMapViewDelegate>

@property (nonatomic, strong, nullable) NSTimer *timer;
@property MGLShapeSource *source;

@end

@implementation LiveDataExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Dark style.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.tintColor = [UIColor darkGrayColor];
    
    // Set the map view‘s delegate property.
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add a source to the map. https://wanderdrone.appspot.com/ generates coordinates for simulated paths.
    NSURL *url = [NSURL URLWithString:@"https://wanderdrone.appspot.com/"];
    _source = [[MGLShapeSource alloc] initWithIdentifier:@"wanderdrone" URL:url options:nil];
    [style addSource:_source];
    
    // Add a Maki icon to the map to represent the drone's coordinate. The specified icon is included in the Mapbox Dark style's sprite sheet. For more information about Maki icons, see https://www.mapbox.com/maki-icons/
    MGLSymbolStyleLayer *droneLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"wanderdrone" source:_source];
    droneLayer.iconImageName = [NSExpression expressionForConstantValue:@"rocket-15"];
    [style addLayer:droneLayer];
    
    // Create a timer that calls the `updateUrl` function every 1.5 seconds.
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateURL) userInfo:nil repeats:YES];
}

- (void)updateURL {
    // Update the icon's position by setting the `url` property on the source.
    _source.URL = _source.URL;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Invalidate the timer if the view will disappear.
    [_timer invalidate];
    _timer = nil;
}

@end
