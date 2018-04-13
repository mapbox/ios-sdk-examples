#import "DDSCircleLayerTutorialViewController.h"

@import Mapbox;

@interface DDSCircleLayerTutorialViewController () <MGLMapViewDelegate>

@end

@implementation DDSCircleLayerTutorialViewController

// #-code-snippet: dds-circle initialize-map-objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Light style.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL: [MGLStyle lightStyleURL]];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.tintColor = [UIColor darkGrayColor];
    
    // Set the map’s center coordinate and zoom level.
    mapView.centerCoordinate = CLLocationCoordinate2DMake(44.971, -93.261);
    mapView.zoomLevel = 10;
    
    [self.view addSubview:mapView];
    mapView.delegate = self;
}
// #-end-code-snippet: dds-circle initialize-map-objc

// Wait until the style is loaded before modifying the map style.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // #-code-snippet: dds-circle add-vector-source-objc
    // "mapbox://examples.2uf7qges" is the map ID referencing a tileset
    // created from the GeoJSON data uploaded earlier.
    MGLSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"historical-places" configurationURL:[NSURL URLWithString:@"mapbox://cmcg.71x8omg1"]];
    
    [mapView.style addSource:source];
    // #-end-code-snippet: dds-circle add-vector-source-objc

    // #-code-snippet: dds-circle add-circle-layer-objc
    MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"tree-style" source:source];
    
    // The source name from the source's TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
    layer.sourceLayerIdentifier = @"HPC_landmarks-39z2b05";
    // #-end-code-snippet: dds-circle add-circle-layer-objc
    
    // #-code-snippet: dds-circle add-stops-dictionary-objc
    NSDictionary *stops = @{
        @0: [UIColor colorWithRed:1.00 green:0.72 blue:0.85 alpha:1.0],
        @2: [UIColor colorWithRed:0.69 green:0.48 blue:0.73 alpha:1.0],
        @4: [UIColor colorWithRed:0.61 green:0.31 blue:0.47 alpha:1.0],
        @7: [UIColor colorWithRed:0.43 green:0.20 blue:0.38 alpha:1.0],
        @16: [UIColor colorWithRed:0.33 green:0.17 blue:0.25 alpha:1.0]
    };
    // #-end-code-snippet: dds-circle add-stops-dictionary-objc
    
    // #-code-snippet: dds-circle add-style-layer-objc
    // Style the circle layer color based on the above categorical stops.
    layer.circleColor = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(AGE, %@, %@)", [UIColor colorWithRed:1.0 green:0.72 blue:0.85 alpha:1.0], stops];

    layer.circleRadius = [NSExpression expressionForConstantValue:@3];
    
    [mapView.style addLayer:layer];
    // #-end-code-snippet: dds-circle add-style-layer-objc
}

@end
