#import "ShapeCollectionFeatureExample.h"
@import Mapbox;

NSString *const MBXExampleShapeCollectionFeature = @"ShapeCollectionFeatureExample";

@interface ShapeCollectionFeatureExample () <MGLMapViewDelegate>

@end

@implementation ShapeCollectionFeatureExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame: self.view.bounds styleURL: [MGLStyle lightStyleURLWithVersion:9]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.897435, -77.039679) zoomLevel:12 animated:NO];
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [[NSURL alloc] initWithString: @"https://api.mapbox.com/datasets/v1/mapbox/cj004g2ay04vj2xls3oqdu2ou/features?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpemc0YWlpNzAwcXUyd21ldDV6OWpxMGwifQ.A92RQZpwUgtGtCmdSE4-ow"];
    if (url) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        MGLShape *feature = [MGLShape shapeWithData:data encoding: NSUTF8StringEncoding error: nil];
        
        MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"transit" shape:feature options:nil];
        
        MGLCircleStyleLayer *circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"stations" source:source];
        
        circleLayer.predicate = [NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"TYPE", @"Station"]];
        circleLayer.circleColor = [MGLStyleValue valueWithRawValue: [UIColor redColor]];
        circleLayer.circleRadius = [MGLStyleValue valueWithRawValue:@6];
        circleLayer.circleStrokeWidth = [MGLStyleValue valueWithRawValue:@2];
        circleLayer.circleStrokeColor = [MGLStyleValue valueWithRawValue: [UIColor blackColor]];

        MGLLineStyleLayer *lineLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"rail-line" source: source];
        lineLayer.predicate = [NSPredicate predicateWithFormat:@"%K == %@" argumentArray:@[@"TYPE", @"Rail line"]];
        lineLayer.lineColor = [MGLStyleValue valueWithRawValue:[UIColor redColor]];
        lineLayer.lineWidth = [MGLStyleValue valueWithRawValue:@2];
        
        [style addSource:source];
        [style addLayer:circleLayer];
        [style insertLayer:lineLayer belowLayer:circleLayer];
    }
    
}

@end
