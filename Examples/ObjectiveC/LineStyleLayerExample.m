#import "LineStyleLayerExample.h"
@import Mapbox;

NSString *const MBXExampleLineStyleLayer = @"LineStyleLayerExample";

@interface LineStyleLayerExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

@implementation LineStyleLayerExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736)
                zoomLevel:11
                 animated:NO];

    [self.view addSubview:self.mapView];

    self.mapView.delegate = self;
}

// Wait until the map is loaded before adding to the map.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self loadGeoJSON];
}

- (void)loadGeoJSON {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"geojson"];
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
    MGLSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:shape options:nil];
    [self.mapView.style addSource:source];

    // Create new layer for the line.
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    layer.lineJoin = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineCap:MGLLineCapRound]];
    layer.lineColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:59/255.0 green:178/255.0 blue:208/255.0 alpha:1]];
    layer.lineWidth = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                       @{@14: @2, @18: @20}];
    
    // We can also add a second layer that will draw a stroke around the original line.
    MGLLineStyleLayer *casingLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline-case" source:source];
    // Copy these attributes from the main line layer.
    casingLayer.lineJoin = layer.lineJoin;
    casingLayer.lineCap = layer.lineCap;
    // Line gap width represents the space before the outline begins, so should match the main line’s line width exactly.
    casingLayer.lineGapWidth = layer.lineWidth;
    // Stroke color slightly darker than the line color.
    casingLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:41/255.0 green:145/255.0 blue:171/255.0 alpha:1]];
    // Use a style function to gradually increase the stroke width between zoom levels 14 and 18.
    // TODO: Default value - 1.5
    casingLayer.lineWidth = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                             @{@14: @1, @18: @4}];

    // Just for fun, let’s add another copy of the line with a dash pattern.
    MGLLineStyleLayer *dashedLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline-dash" source:source];
    dashedLayer.lineJoin = layer.lineJoin;
    dashedLayer.lineCap = layer.lineCap;
    dashedLayer.lineWidth = layer.lineWidth;
    dashedLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    dashedLayer.lineOpacity = [NSExpression expressionForConstantValue:@0.5];
    // Dash pattern in the format [dash, gap, dash, gap, ...]. You’ll want to adjust these values based on the line cap style.
    dashedLayer.lineDashPattern = [NSExpression expressionForConstantValue:@[@0, @1.5]];

    [self.mapView.style addLayer:layer];
    [self.mapView.style addLayer:dashedLayer];
    [self.mapView.style insertLayer:casingLayer belowLayer:layer];
}

@end

