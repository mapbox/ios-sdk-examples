//
//  POIAlongRoute.m
//  Examples
//
//  Created by Takuto Suzuki on 2020/08/28.
//  Copyright © 2020 Mapbox. All rights reserved.
//

#import "POIAlongRouteExample.h"
@import Mapbox;

NSString *const MBXExamplePOIAlongRoute = @"POIAlongRouteExample";

@interface POIAlongRouteExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

@implementation POIAlongRouteExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.52214, -122.63748)
                           zoomLevel:18
                             animated:NO];

    [self.view addSubview:self.mapView];

    self.mapView.delegate = self;
}

// Wait until the map is loaded before adding to the map.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self loadGeoJSON];
    [self restrictPOIVisibleShape];
    [self setCamera];
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

- (void)setCamera {
    MGLMapCamera * camera = self.mapView.camera;
    camera.heading = 249.37706203842038;
    camera.pitch = 60;
    camera.centerCoordinate = CLLocationCoordinate2DMake(45.52199780570582, -122.6418837958432);

    [self.mapView setCamera: camera];
    [self.mapView setZoomLevel:15.062187320447523 animated:false];
}

- (void)drawPolyline:(NSData *)geoJson {
    // Add our GeoJSON data to the map as an MGLShapeSource.
    // We can then reference this data from an MGLStyleLayer.
    MGLShape *shape = [MGLShape shapeWithData:geoJson encoding:NSUTF8StringEncoding error:nil];
    MGLSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:shape options:nil];
    [self.mapView.style addSource:source];

    // Create new layer for the line.
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    
    // Set the line join and cap to a rounded end.
    layer.lineJoin = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineJoin:MGLLineJoinRound]];
    layer.lineCap = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineCap:MGLLineCapRound]];
    
    // Set the line color to a constant blue color.
    layer.lineColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:59/255.0f green:178/255.0f blue:208/255.0f alpha:1]];
    
    // Use `NSExpression` to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve
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
    casingLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:41/255.0f green:145/255.0f blue:171/255.0f alpha:1]];
    // Use a style function to gradually increase the stroke width between zoom levels 14 and 18.
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
    
    MGLSymbolStyleLayer *poiLayer = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"poi-label"];
    [self.mapView.style insertLayer:layer belowLayer:poiLayer];
    [self.mapView.style insertLayer:dashedLayer belowLayer:layer];
    [self.mapView.style insertLayer:casingLayer belowLayer:layer];
}

- (void)restrictPOIVisibleShape {
    MGLSymbolStyleLayer *poiLayer = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"poi-label"];
    MGLSymbolStyleLayer *roadLabelLayer = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"road-label"];
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(45.52288837762333, -122.63730626171188),
        CLLocationCoordinate2DMake(45.52299746891552, -122.65455070022612),
        CLLocationCoordinate2DMake(45.52177017968134, -122.65747018755947),
        CLLocationCoordinate2DMake(45.51931552089448, -122.65992255691913),
        CLLocationCoordinate2DMake(45.513696676587045, -122.66015611590598),
        CLLocationCoordinate2DMake(45.51375123117057, -122.66696825301655),
        CLLocationCoordinate2DMake(45.51222368283956, -122.6672018120034),
        CLLocationCoordinate2DMake(45.51225096085216, -122.6571977020749),
        CLLocationCoordinate2DMake(45.51822452705878, -122.6570419960839),
        CLLocationCoordinate2DMake(45.52106106703124, -122.65392787626189),
        CLLocationCoordinate2DMake(45.52114288817623, -122.63567134880579),
        CLLocationCoordinate2DMake(45.52288036393409, -122.63657745074761),
        CLLocationCoordinate2DMake(45.52291377640398, -122.6373404839605)};
    MGLPolygon *shape = [MGLPolygon polygonWithCoordinates: coordinates count: 13 interiorPolygons: nil];
    poiLayer.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", shape];
    roadLabelLayer.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", shape];
}

@end

