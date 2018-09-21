#import "AnimatedFillLayerExample.h"

@import Mapbox;

// Convert RGB values to UIColor.
#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

NSString *const MBXExampleAnimatedFillLayer = @"AnimatedFillLayerExample";

@interface AnimatedFillLayerExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UISlider *slider;
@property (nonatomic) MGLFillStyleLayer *radarLayer;
@property (nonatomic, readonly) NSDictionary *fillColors;

@end

@implementation AnimatedFillLayerExample

// Create a stops dictionary. This will be used to determine the color of polygons within the fill layer.
- (NSDictionary *)fillColors {
    return @{
             @(8): RGB(20, 160, 240),
             @(18): RGB(20, 190, 240),
             @(36): RGB(20, 220, 240),
             @(54): RGB(20, 250, 240),
             @(72): RGB(20, 250, 160),
             @(90): RGB(135, 250, 80),
             @(108): RGB(250, 250, 0),
             @(126): RGB(250, 180, 0),
             @(144): RGB(250, 110, 0),
             @(162): RGB(250, 40, 0),
             @(180): RGB(180, 40, 40),
             @(198): RGB(110, 40, 80),
             @(216): RGB(80, 40, 110),
             @(234): RGB(50, 40, 140),
             @(252): RGB(20, 40, 170)
             };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.22894, 102.45434) zoomLevel:2 animated:NO];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 37;
    self.slider.value = 0;
    [self.slider addTarget:self action:@selector(slideValueChanged:event:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Access a tileset that contains multiple polygons. This radar data was retrieved from the China Meteorological Data Service Center on June 26, 2018. "mapbox://examples.dwtmhwpu" is a map id that references a tileset mapbox.com/help/define-map-id/
    NSURL *url = [NSURL URLWithString:@"mapbox://examples.dwtmhwpu"];
    
    // Create a MGLVectorTileSource from the vector tileset and add it to the map's style.
    MGLVectorTileSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"weather-source" configurationURL:url];
    [style addSource:source];
    
    // Create a fill layer from the vector tileset. The fill layer is a visual representation of the tileset.
    MGLFillStyleLayer *fillLayer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"weather-layer" source:source];
   
   // The source layer identifier comes from the source's TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
    fillLayer.sourceLayerIdentifier = @"201806261518";
    
    // Use the stops dictionary created earlier to determine the fill layer's color. The stops dictionary uses values for the `value` attribute as a key, and UIColor objects as the values.
    fillLayer.fillColor = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(value, %@, %@)", [UIColor clearColor], [self fillColors]];
    fillLayer.fillOpacity = [NSExpression expressionForConstantValue:@(0.7)];
    fillLayer.fillOutlineColor = [NSExpression expressionForConstantValue:[UIColor clearColor]];
    [style addLayer:fillLayer];
    
    // Store the layer as a property in order to update it later. If your use case involves style changes, do not store the layer as a property. Instead, access the layer using its layer identifier.
    self.radarLayer = fillLayer;
}

- (void)slideValueChanged:(UISlider *)silder event:(UIEvent *)event {
   // Filter the layer based on the value for the attribute `idx`.
    self.radarLayer.predicate = [NSPredicate predicateWithFormat:@"idx == %d", (int)silder.value];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.slider.frame = [self adjustSliderFrame];
}

- (CGRect)adjustSliderFrame {
    if (UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationPortrait) {
        return CGRectMake(10,
                          self.view.frame.size.height - 60 - self.bottomLayoutGuide.length,
                          self.view.frame.size.width - 20,
                          20);
    }
    return CGRectMake(self.topLayoutGuide.length,
                      self.view.frame.size.height - 60 - self.bottomLayoutGuide.length,
                      self.view.frame.size.width - self.topLayoutGuide.length - 20,
                      20);
}

- (void)didChangeOrientation {
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.frame = [self adjustSliderFrame];
    }];
}

@end
