#import "DDSCircleLayerExample.h"
@import Mapbox;

NSString *const MBXExampleDDSCircleLayer = @"DDSCircleLayerExample";

@interface DDSCircleLayerExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation DDSCircleLayerExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a new map view using the Mapbox Light style.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
        styleURL:[MGLStyle lightStyleURL]];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.tintColor = [UIColor darkGrayColor];
    
    // Set the map’s center coordinate and zoom level.
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(38.897,-77.039);
    self.mapView.zoomLevel = 10.5;
    
    self.mapView.delegate = self;
    [self.view addSubview: self.mapView];
}

// Wait until the style is loaded before modifying the map style.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // "mapbox://examples.2uf7qges" is a map ID referencing a tileset. For more
    // more information, see mapbox.com/help/define-map-id/
    MGLSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"trees" configurationURL:[NSURL URLWithString:@"mapbox://examples.2uf7qges"]];
    
    [self.mapView.style addSource:source];
    
    MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier: @"tree-style" source:source];
    
    // The source name from the source's TileJSON metadata: mapbox.com/api-documentation/maps/#retrieve-tilejson-metadata
    layer.sourceLayerIdentifier = @"yoshino-trees-a0puw5";
    
    // Stops based on age of tree in years.
    NSDictionary *stops = @{
        @0: [UIColor colorWithRed:1.00f green:0.72f blue:0.85f alpha:1.0f],
        @2: [UIColor colorWithRed:0.69f green:0.48f blue:0.73f alpha:1.0f],
        @4: [UIColor colorWithRed:0.61f green:0.31f blue:0.47f alpha:1.0f],
        @7: [UIColor colorWithRed:0.43f green:0.20f blue:0.38f alpha:1.0f],
        @16: [UIColor colorWithRed:0.33f green:0.17f blue:0.25f alpha:1.0f]
    };
    
    // Style the circle layer color based on the above stops dictionary.
    layer.circleColor = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(AGE, %@, %@)", [UIColor colorWithRed:1.0f green:0.72f blue:0.85f alpha:1], stops];
 
    layer.circleRadius = [NSExpression expressionForConstantValue:@3];
    
    [self.mapView.style addLayer:layer];
}

@end
