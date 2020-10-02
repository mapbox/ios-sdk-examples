#import "DetectTilesetErrorExample.h"
@import Mapbox;

NSString *const MBXExampleDetectTilesetError = @"DetectTilesetErrorExample";


@interface MyObserver: MGLObserver
@end

@implementation MyObserver
- (void) notifyWithEvent:(MGLEvent *)event {
    [super notifyWithEvent:event];
    NSDictionary* data = (NSDictionary*) event.data;
    if (!data) {
        return;
    }
    NSDictionary* request = (NSDictionary*)[data valueForKey: @"request"];
    if (!request) {
        return;
    }
    NSString* dataSource = [data valueForKey: @"data-source"];
    if (![dataSource isEqual: @"network"]) {
        return;
    }
    NSDictionary* response = (NSDictionary*)[data valueForKey: @"response"];
    if (!response) {
        return;
    }
    NSDictionary* error = [response valueForKey: @"error"];
    NSLog(@"network request: %@, errors: %@", request, error);
}
@end


@interface DetectTilesetErrorExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLStyleLayer *contoursLayer;
@property (nonatomic) MyObserver *observer;
@end

@implementation DetectTilesetErrorExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.observer = [[MyObserver alloc] init];
    [self.mapView subscribeForObserver: self.observer event: MGLEventTypeResourceRequest];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Set the map's center coordinate
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.745395, -119.594421)
                zoomLevel:11
                 animated:NO];

    [self.view addSubview:self.mapView];

    // Set the delegate property of our map view to self after instantiating it
    self.mapView.delegate = self;
}

- (void)dealloc {
    if (self.observer) {
        [self.mapView unsubscribeForObserver: self.observer];
    }
}

// Wait until the style is loaded before modifying the map style
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self addLayer];
}

- (void)addLayer {
    MGLSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"contours" configurationURL:[NSURL URLWithString:@"mapbox://badtilesource"]];
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"contours" source:source];
    [self.mapView.style addSource:source];
    [self.mapView.style addLayer:layer];
}

@end
