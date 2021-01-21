#import "LineGradientExample.h"
@import Mapbox;
@interface LineGradientExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

NSString *const MBXExampleLineGradient = @"LineGradientExample";

@implementation LineGradientExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.875, -77.035)
                            zoomLevel:12
                             animated:NO];
    
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
}

// Wait until the map is loaded before adding line layer to the map.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self loadGeoJSON];
}

- (void)loadGeoJSON {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"iOSLineGeoJSON" ofType:@"geojson"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawPolyline:jsonData];
        });
    });
}

- (void)drawPolyline:(NSData *)geoJson {
    // Add our GeoJSON data to the map as an MGLShapeSource.
    // We can then reference this data from an MGLStyleLayer.
    MGLShape *shape = [MGLShape shapeWithData:geoJson encoding:NSUTF8StringEncoding error:nil];
    MGLSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:shape options: @{MGLShapeSourceOptionLineDistanceMetrics:@YES}];
    [self.mapView.style addSource:source];
    
    // Create new layer for the line.
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    
    // Set the line join and cap to a rounded end.
    layer.lineJoin = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineJoin:MGLLineJoinRound]];
    layer.lineCap = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineCap:MGLLineCapRound]];
    
    NSDictionary *stops = @{
        @0: UIColor.blueColor,
        @0.1: UIColor.purpleColor,
        @0.3: UIColor.cyanColor,
        @0.5: UIColor.greenColor,
        @0.7: UIColor.yellowColor,
        @1: UIColor.redColor
    };
    
    
    // Set the line color to a gradient
    layer.lineGradient = [NSExpression expressionWithFormat: @"mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops];
    
    // Use `NSExpression` to allow the appearance of your gradient to change and become more detailed with the map’s zoom level
    layer.lineWidth = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                       @{@14: @10, @18: @20}];
    [self.mapView.style addLayer:layer];
    
}
@end
