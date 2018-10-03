#import "LineGradientExample.h"
@import Mapbox;

NSString *const MBXExampleLineGradient = @"LineGradientExample";

@interface LineGradientExample ()<MGLMapViewDelegate>

@end

@implementation LineGradientExample

- (void)viewDidLoad {
    [super viewDidLoad];
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle lightStyleURL]];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    mapView.delegate = self;
    
    // Set the map’s center coordinate and zoom level.
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.875, -77.035)
                       zoomLevel:12
                        animated:NO];
    
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"line-gradient" ofType:@"geojson"]];
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"line-source" URL:url options:nil];
    
    
    [style addSource:source];
    
    MGLLineStyleLayer *polylineStyle = [[MGLLineStyleLayer alloc] initWithIdentifier:@"lineStyle" source:source];
    polylineStyle.lineWidth = [NSExpression expressionForConstantValue:@14];
    polylineStyle.lineCap = [NSExpression expressionForConstantValue:@"round"];
    
    NSDictionary *stops = @{
                            @0: UIColor.blueColor,
                            @0.1: UIColor.purpleColor,
                            @0.3: UIColor.cyanColor,
                            @0.5: UIColor.greenColor,
                            @0.7: UIColor.yellowColor,
                            @1: UIColor.redColor
                            };
        
    NSExpression *gradientExpression = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops];
    
    polylineStyle.lineColor = gradientExpression;
    
    [style addLayer:polylineStyle];
    
}

@end

