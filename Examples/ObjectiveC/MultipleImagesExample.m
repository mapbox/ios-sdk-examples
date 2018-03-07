
#import "MultipleImagesExample.h"
@import Mapbox;

NSString *const MBXExampleMultipleImages = @"MultipleImagesExample";

@interface MultipleImagesExample () <MGLMapViewDelegate>

@end

@implementation MultipleImagesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle outdoorsStyleURL]];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.7, -119.7) zoomLevel:10 animated:NO];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add Hiker by Nicolas Vicent from the Noun Project to the map's style.
    
    [style setImage:[UIImage imageNamed:@"hiker-icon"] forName:@"trailhead"];
    NSURL *url = [[NSURL alloc] initWithString:@"mapbox://jordankiley.asry9k5m"];
    MGLVectorSource *source = [[MGLVectorSource alloc] initWithIdentifier:@"yosemite-pois" configurationURL:url];
    [style addSource:source];
    
    MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"yosemite-pois" source:source];
    layer.sourceLayerIdentifier = @"Yosemite_POI-8mmqrb";
    
    layer.iconImageName = [NSExpression expressionWithFormat:@"FUNCTION(%@, 'valueForKeyPath:', POITYPE)", @{@"Picnic Area" : @"picnic-site-15", @"Restroom" : @"toilet-15", @"Parking" : @"parking-15", @"Campsite" : @"campsite-15", @"Trailhead" : @"trailhead"}];

    // This should be a composite function.
    layer.iconOpacity = [NSExpression expressionWithFormat:@"FUNCTION($zoomLevel, 'mgl_stepWithMinimum:stops:', 1, %@)", @{@16: @0}];
    [style addLayer:layer];
}

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Current zoom level: %f", mapView.zoomLevel);
}

@end
