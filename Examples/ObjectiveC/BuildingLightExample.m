
#import "BuildingLightExample.h"
#import "TestingSupport.h"
@import Mapbox;

@interface BuildingLightExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLLight *light;
@property (nonatomic) UISlider *slider;

@end

NSString *const MBXExampleBuildingLight = @"BuildingLightExample";

@implementation BuildingLightExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the map style to Mapbox Streets Style version 9. The map's source will be queried later in this example.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle streetsStyleURLWithVersion:9]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;

    // Center the map on the Flatiron Building in New York, NY.
    self.mapView.camera = [MGLMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.7411, -73.9897) fromDistance:600 pitch:45 heading:200];
    
    [self.view addSubview:self.mapView];
    
    [self addSlider];
}

// Add a slider to the map view. This will be used to adjust the map's light object.
- (void)addSlider {
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 8, self.view.frame.size.height - 60, self.view.frame.size.width * 0.75, 20)];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.slider.minimumValue = -180;
    self.slider.maximumValue = 180;
    self.slider.value = 0;

    [self.slider addTarget:self action:@selector(shiftLight) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Add a MGLFillExtrusionStyleLayer.
    [self addFillExtrusionLayer:style];
    
    // Create an MGLLight object.
    self.light = [[MGLLight alloc] init];
    
    // Create an MGLSphericalPosition and set the radial, azimuthal, and polar values.
    // Radial : Distance from the center of the base of an object to its light. Takes a CGFloat.
    // Azimuthal : Position of the light relative to its anchor. Takes a CLLocationDirection.
    // Polar : The height of the light. Takes a CLLocationDirection.
    MGLSphericalPosition position = MGLSphericalPositionMake(5, 180, 80);
    self.light.position = [NSExpression expressionForConstantValue:[NSValue valueWithMGLSphericalPosition:position]];
    
    // Set the light anchor to the map and add the light object to the map view's style. The light anchor can be the viewport (or rotates with the viewport) or the map (rotates with the map). To make the viewport the anchor, replace `map` with `viewport`.
    
    self.light.anchor = [NSExpression expressionForConstantValue:@"map"];
    
    style.light = self.light;
}

- (void)shiftLight {
    // Use the slider's value to change the light's polar value.
    MGLSphericalPosition position = MGLSphericalPositionMake(5, 180, self.slider.value);
    self.light.position = [NSExpression expressionForConstantValue:[NSValue valueWithMGLSphericalPosition:position]];
    self.mapView.style.light = self.light;
}

- (void)addFillExtrusionLayer:(MGLStyle *)style {
    // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
    MGLSource *source = [style sourceWithIdentifier:@"composite"];
    MGLFillExtrusionStyleLayer *layer = [[MGLFillExtrusionStyleLayer alloc] initWithIdentifier:@"extrusion-layer" source:source];
    layer.sourceLayerIdentifier = @"building";
    layer.fillExtrusionHeight = [NSExpression expressionForKeyPath:@"height"];
    layer.fillExtrusionBase = [NSExpression expressionForKeyPath:@"min_height"];
    layer.fillExtrusionOpacity = [NSExpression expressionForConstantValue:@0.75];
    layer.fillExtrusionColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    
    // Access the map's layer with the identifier "poi-scalerank3" and insert the fill extrusion layer below it.
    MGLStyleLayer *symbolLayer = [style layerWithIdentifier:@"poi-scalerank3"];
    [style insertLayer:layer belowLayer:symbolLayer];
}

@end

