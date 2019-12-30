#import "DDSCircleLayerTutorialViewController.h"

@import Mapbox;

@interface DDSCircleLayerTutorialViewController () <MGLMapViewDelegate>

@end

@implementation DDSCircleLayerTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL: [MGLStyle lightStyleURL]];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(44.971, -93.261)
                       zoomLevel:10
                        animated:NO];
    
    [self.view addSubview:mapView];
    mapView.delegate = self;
}


- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    MGLSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"historical-places" configurationURL:[NSURL URLWithString:@"mapbox://examples.5zzwbooj"]];
    
    [mapView.style addSource:source];

    MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"landmarks" source:source];
    
    layer.sourceLayerIdentifier = @"HPC_landmarks-b60kqn";
    
    layer.circleColor = [NSExpression expressionForConstantValue:[UIColor colorWithRed:0.67 green:0.28 blue:0.13 alpha:1.0]];
    
    layer.circleOpacity = [NSExpression expressionForConstantValue:@"0.8"];

    NSDictionary *zoomStops = @{
        @10: [NSExpression expressionWithFormat:@"(2018 - Constructi) / 30"],
        @13: [NSExpression expressionWithFormat:@"(2018 - Constructi) / 10"]
    };
    
    layer.circleRadius = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:(Constructi, 'linear', nil, %@)", zoomStops];
    
    [mapView.style addLayer:layer];
}

@end
