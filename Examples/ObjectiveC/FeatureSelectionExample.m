#import "FeatureSelectionExample.h"
@import Mapbox;

NSString const *MBXExampleFeatureSelection = @"FeatureSelectionExample";

@interface FeatureSelectionExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) NSString *layerIdentifier;

@end

@implementation FeatureSelectionExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.23225, -97.91015)];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.mapView];

    // Store the name of the style layer in which states will be drawn.
    self.layerIdentifier = @"state-layer";
    
    // Add a tap gesture recognizer to the map view.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gesture.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:gesture];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Load a tileset containing U.S. states and their population density. For more information about working with tilesets, see: https://www.mapbox.com/help/studio-manual-tilesets/
    NSURL *url = [NSURL URLWithString:@"mapbox://examples.69ytlgls"];
    
    MGLVectorTileSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"state-source" configurationURL:url];
    [style addSource:source];

    MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:self.layerIdentifier source:source];
    
    // Access the tileset layer.
    layer.sourceLayerIdentifier = @"stateData_2-dx853g";
    
    // Create a stops dictionary. This defines the relationship between population density and a UIColor.
    NSDictionary *stops = @{
            @0: [UIColor yellowColor],
            @600: [UIColor redColor],
            @1200: [UIColor blueColor]
        };
    
    // Style the fill color using the stops dictionary, exponential interpolation mode, and the feature attribute name.
    layer.fillColor = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(density, 'linear', nil, %@)", stops];

    // Insert the new layer below the Mapbox Streets layer that contains state border lines. See the layer reference for more information about layer names: https://www.mapbox.com/vector-tiles/mapbox-streets-v7/
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"admin-3-4-boundaries"];
    
    [style insertLayer:layer belowLayer:symbolLayer];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    
    // Get the CGPoint where the user tapped.
    CGPoint spot = [gesture locationInView:self.mapView];
    
    // Access the features at that point within the state layer.
    NSArray *features = [self.mapView visibleFeaturesAtPoint:spot
                                inStyleLayersWithIdentifiers:[NSSet setWithObject:self.layerIdentifier]];
    
    MGLPolygonFeature *feature = features.firstObject;
    
    // Get the name of the selected state.
    NSString *state = [feature attributeForKey:@"name"];
    
    [self changeOpacityBasedOn:state];
}

- (void)changeOpacityBasedOn:(NSString*)name {
    MGLFillStyleLayer *layer = (MGLFillStyleLayer *)[self.mapView.style layerWithIdentifier:self.layerIdentifier];
    
    // Check if a state was selected, then change the opacity of the states that were not selected.
    if (name.length > 0) {
        layer.fillOpacity = [NSExpression expressionWithFormat:@"MGL_MATCH(name, %@, 1, 0)", name];
    } else {
        // Reset the opacity for all states if the user did not tap on a state.
        layer.fillOpacity = [NSExpression expressionForConstantValue:@1];
    }
}

@end
