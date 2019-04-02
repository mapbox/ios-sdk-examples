#import "LabelPlacementExample.h"
@import Mapbox;

NSString *const MBXExampleLabelPlacement = @"LabelPlacementExample";

@interface LabelPlacementExample ()<MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation LabelPlacementExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's initial style, center coordinate, and zoom level
    self.mapView.styleURL = [MGLStyle streetsStyleURL];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.791282, -122.396301)
                            zoomLevel:15.0
                             animated:NO];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    MGLSymbolStyleLayer *poiLabelLayers = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"poi-label"];
    poiLabelLayers.textAnchor = nil;
    poiLabelLayers.textOffset = nil;
    poiLabelLayers.symbolPlacement = nil;
    poiLabelLayers.textOffset = nil;
//    poiLabelLayers.textVariableAnchor = [NSExpression expressionForConstantValue:@[@(MGLTextAnchorTop), @(MGLTextAnchorRight)]];
//    poiLabelLayers.textRadialOffset = [NSExpression expressionForConstantValue:@(1.2)];
//    poiLabelLayers.textJustification = [NSExpression expressionForConstantValue:@(MGLTextJustificationAuto)];
}

@end
