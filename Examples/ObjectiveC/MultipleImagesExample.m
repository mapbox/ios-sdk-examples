
#import "MultipleImagesExample.h"
@import Mapbox;

NSString *const MBXExampleMultipleImages = @"MultipleImagesExample";

@interface MultipleImagesExample () <MGLMapViewDelegate>

@end

@implementation MultipleImagesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create and add a map view.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle outdoorsStyleURL]];
    
    // Center the map on Yosemite National Park, United States.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.761, -119.624) zoomLevel:10 animated:NO];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add icons from the U.S. National Parks Service to the map's style.
    [style setImage:[UIImage imageNamed:@"nps-restrooms"] forName:@"restrooms"];
    [style setImage:[UIImage imageNamed:@"nps-trailhead"] forName:@"trailhead"];
    [style setImage:[UIImage imageNamed:@"nps-picnic-area"] forName:@"picnic-area"];
    
    // Access a vector tileset that contains places of interest at Yosemite National Park. This tileset was created by uploading NPS shapefiles to Mapbox Studio.
    NSURL *url = [[NSURL alloc] initWithString:@"mapbox://examples.ciuz0vpc"];
    MGLVectorTileSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"yosemite-pois" configurationURL:url];
    [style addSource:source];
    
    MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"yosemite-pois" source:source];
    
    // Access the layer that contains the POI data.
    layer.sourceLayerIdentifier = @"Yosemite_POI-38jhes";
    
    // Create a stops dictionary with keys that are possible values for 'POITYPE', paired with icon images that will represent those features.
    NSDictionary *poiIcons = @{@"Picnic Area" : @"picnic-area", @"Restroom" : @"restrooms", @"Trailhead" : @"trailhead"};
    
    // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
    layer.iconImageName = [NSExpression expressionWithFormat:@"FUNCTION(%@, 'valueForKeyPath:', POITYPE)", poiIcons];

    [style addLayer:layer];
}

@end
