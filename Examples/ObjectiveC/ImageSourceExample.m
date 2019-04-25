
#import "ImageSourceExample.h"
@import Mapbox;

NSString *const MBXExampleImageSource = @"ImageSourceExample";

@interface ImageSourceExample () <MGLMapViewDelegate>
@end

@implementation ImageSourceExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(43.457, -75.789) zoomLevel:4 animated:NO];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.tintColor = [UIColor darkGrayColor];
    
    // Set the map view‘s delegate property.
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Set the coordinate bounds for the raster image.
    MGLCoordinateQuad coordinates = MGLCoordinateQuadMake(
        CLLocationCoordinate2DMake(46.437, -80.425),
        CLLocationCoordinate2DMake(37.936, -80.425),
        CLLocationCoordinate2DMake(37.936, -71.516),
        CLLocationCoordinate2DMake(46.437, -71.516)
    );
    
    // Create an MGLImageSource, used to add georeferenced raster images to a map.
    UIImage *radarImage = [UIImage imageNamed:@"radar.gif"];
    MGLImageSource *source = [[MGLImageSource alloc] initWithIdentifier:@"radar" coordinateQuad:coordinates image:radarImage];
    [style addSource:source];

    // Create a raster layer from the MGLImageSource.
    MGLRasterStyleLayer *radarLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"radar-layer" source:source];

    // Insert the raster layer below the map's symbol layers.
    for (MGLStyleLayer *layer in style.layers.reverseObjectEnumerator) {
        if (![layer isKindOfClass:[MGLSymbolStyleLayer class]]) {
            [style insertLayer:radarLayer aboveLayer:layer];
            break;
        }
    }
}

@end
