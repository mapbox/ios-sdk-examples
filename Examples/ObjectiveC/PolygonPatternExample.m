#import "PolygonPatternExample.h"
@import Mapbox;

NSString *const MBXExamplePolygonPattern = @"PolygonPatternExample";

@interface PolygonPatternExample ()<MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation PolygonPatternExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the map’s size, style, center coordinate, zoom level, and tint color.
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.frame styleURL:[MGLStyle darkStyleURLWithVersion:9]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.849534447, -77.039222717)
                       zoomLevel:8.5
                        animated:NO];
    mapView.tintColor = [UIColor lightGrayColor];
    
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Set the UIImage to be used for the fill pattern.
    UIImage *fillPatternImage = [UIImage imageNamed:@"stripe-pattern"];
    
    // Add the fill pattern image to used by the style layer.
    [style setImage:fillPatternImage forName:@"stripe-pattern"];
    
    // "mapbox://examples.0cd7imtl" is a map ID referencing a tileset containing vector data.
    // For more information, see mapbox.com/help/define-map-id/
    MGLSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"drone-restrictions" configurationURL:[NSURL URLWithString:@"mapbox://examples.0cd7imtl"]];
    
    [style addSource:source];
    
    // Create a style layer using the vector source.
    MGLFillStyleLayer *layer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"drone-restrictions-style" source:source];
    
    // Set the source's identifier using the source name retrieved from its
    // TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
    // You can also retrieve the source layer identifier in the Mapbox Studio layers list,
    // if your source data was added using the Mapbox Studio style editor.
    layer.sourceLayerIdentifier = @"drone-restrictions-3f6lsg";
    
    // Set the fill pattern and opacity for the style layer. The NSExpression
    // object is a generic container for a style attribute value. In this case,
    // it is a reference to the fillPatternImage.
    layer.fillPattern = [NSExpression expressionForConstantValue:@"stripe-pattern"];
    layer.fillOpacity = [NSExpression expressionForConstantValue:@0.5];
    
    // Insert the pattern style layer below the layer contining city labels. If the
    // layer is not found, the style layer will be added above all other layers within the
    // Mapbox Dark style. NOTE: The "place-city-sm" layer is specific to the Mapbox Dark style.
    // Refer to the layers list in Mapbox Studio to confirm which layers are available for
    // use when working with a custom style.
    MGLStyleLayer *cityLabels = [style layerWithIdentifier:@"place-city-sm"];
    if (cityLabels) {
        [style insertLayer:layer belowLayer:cityLabels];
    } else {
        [style addLayer:layer];
    }
}

@end

