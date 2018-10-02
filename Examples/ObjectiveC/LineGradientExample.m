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
    
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(38.852924, -77.044211),
        CLLocationCoordinate2DMake(38.860158, -77.045659),
        CLLocationCoordinate2DMake(38.862326, -77.044232),
        CLLocationCoordinate2DMake(38.865454, -77.040879),
        CLLocationCoordinate2DMake(38.867698, -77.039936),
        CLLocationCoordinate2DMake(38.86943, -77.040338),
        CLLocationCoordinate2DMake(38.872528, -77.04264),
        CLLocationCoordinate2DMake(38.878424, -77.03696),
        CLLocationCoordinate2DMake(38.87937, -77.032309),
        CLLocationCoordinate2DMake(38.880945, -77.030056),
        CLLocationCoordinate2DMake(38.881779, -77.027645),
        CLLocationCoordinate2DMake(38.882645, -77.026946),
        CLLocationCoordinate2DMake(38.885502, -77.026942),
        CLLocationCoordinate2DMake(38.887449, -77.028054),
        CLLocationCoordinate2DMake(38.892088, -77.02806),
        CLLocationCoordinate2DMake(38.892108, -77.03364),
        CLLocationCoordinate2DMake(38.899926, -77.033643)
    };
    
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    MGLPolyline *polylineShape = [MGLPolyline polylineWithCoordinates:coordinates count:numberOfCoordinates];
    
    MGLShapeSource *polylineSource = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" shape:polylineShape options:nil];
    
    [style addSource:polylineSource];
    
    MGLLineStyleLayer *polylineStyle = [[MGLLineStyleLayer alloc] initWithIdentifier:@"lineStyle" source:polylineSource];
    
    [style addLayer:polylineStyle];
    
}

@end

