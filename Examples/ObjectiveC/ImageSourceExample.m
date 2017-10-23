
#import "ImageSourceExample.h"
@import Mapbox;

NSString *const MBXExampleImageSource = @"ImageSourceExample";

@interface ImageSourceExample () <MGLMapViewDelegate>

@end

@implementation ImageSourceExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.frame];
    mapView.delegate = self;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(43.457, -76.437) zoomLevel:4 animated:NO];
    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    MGLCoordinateQuad coordinates = MGLCoordinateQuadMake(CLLocationCoordinate2DMake(46.437, -80.425), CLLocationCoordinate2DMake(37.936, -80.425), CLLocationCoordinate2DMake(37.936, -71.516), CLLocationCoordinate2DMake(46.437, -71.516));
    MGLImageSource *source = [[MGLImageSource alloc] initWithIdentifier:@"radar" coordinateQuad:coordinates URL:[NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/radar.gif"]];
    [style addSource:source];
    
    MGLRasterStyleLayer *layer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"radar-layer" source:source];
    [style addLayer:layer];
}

@end
