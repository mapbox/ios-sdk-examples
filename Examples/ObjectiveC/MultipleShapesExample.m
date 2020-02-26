#import "MultipleShapesExample.h"
@import Mapbox;

NSString *const MBXExampleMultipleShapes = @"MultipleShapesExample";

@interface MultipleShapesExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

@interface MGLStyle (LayerExtensions)
- (void)addLinesFrom:(MGLShapeSource *)source;
- (void)addPointsFrom:(MGLShapeSource *)source;
- (void)addPolygonsFrom:(MGLShapeSource *)source;
@end

@implementation MultipleShapesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure a map view centered on Washington, D.C.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.897435, -77.039679) zoomLevel:12 animated:NO];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // If this data was coming from an external server, we would want to check if NSURL was nil,
    // and perform proper error handling for a web request/response.
    NSURL *url = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"dc-metro" ofType:@"geojson"]];

    // Create a shape source and register it with the map style.
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"dc-data-source" URL:url options:nil];
    [style addSource:source];

    // Add different line, point, and polygon shapes to the map style.
    [style addLinesFrom:source];
    [style addPointsFrom:source];
    [style addPolygonsFrom:source];
}

@end

@implementation MGLStyle (LayerExtensions)

- (void)addLinesFrom:(MGLShapeSource *)source {
    /**
     Configure a line style layer to represent a rail line, filtering out all data from the
     source that is not of `Rail line` type. The `TYPE` is an attribute of the source data
     that can be seen by inspecting the GeoJSON source file, for example:

    {
      "type": "Feature",
      "properties": {
        "NAME": "Dupont Circle",
        "TYPE": "metro-station"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.043416,
          38.909605
        ]
      },
      "id": "994446c244acadeb15d3f9fc18278c73"
    }
    */
    MGLLineStyleLayer *lineLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"rail-line" source: source];
    lineLayer.predicate = [NSPredicate predicateWithFormat:@"TYPE = 'Rail line'"];
    lineLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
    lineLayer.lineWidth = [NSExpression expressionForConstantValue:@2];

    [self addLayer:lineLayer];

}

- (void)addPointsFrom:(MGLShapeSource *)source {
    // Configure a circle style layer to represent rail stations, filtering out all data from
    // the source that is not of `metro-station` type.
    MGLCircleStyleLayer *circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"stations" source:source];
    circleLayer.predicate = [NSPredicate predicateWithFormat:@"TYPE = 'metro-station'"];
    circleLayer.circleColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
    circleLayer.circleRadius = [NSExpression expressionForConstantValue:@6];
    circleLayer.circleStrokeWidth = [NSExpression expressionForConstantValue:@2];
    circleLayer.circleStrokeColor = [NSExpression expressionForConstantValue:[UIColor blackColor]];

    [self addLayer:circleLayer];
}

- (void)addPolygonsFrom:(MGLShapeSource *)source {
    // Configure a fill style layer to represent polygon regions in Washington, D.C.
    // Source data that is not of `neighborhood-region` type will be excluded.
    MGLFillStyleLayer *polygonLayer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"DC-regions" source: source];
    polygonLayer.predicate = [NSPredicate predicateWithFormat:@"TYPE = 'neighborhood-region'"];
    polygonLayer.fillColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:0.27f green:0.41f blue:0.97f alpha: 0.3f]];
    polygonLayer.fillOutlineColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:0.27f green:0.41f blue:0.97f alpha:1]];

    [self addLayer:polygonLayer];
}

@end

