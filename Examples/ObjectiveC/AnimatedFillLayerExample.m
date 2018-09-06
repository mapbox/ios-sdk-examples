#import "AnimatedFillLayerExample.h"

@import Mapbox;

#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

NSString *const MBXExampleAnimatedFillLayer = @"AnimatedFillLayerExample";

@interface AnimatedFillLayerExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UISlider *slider;
@property (nonatomic) MGLFillStyleLayer *radarLayer;
@property (nonatomic, readonly) NSDictionary *fillColors;

@end

@implementation AnimatedFillLayerExample

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
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.22894310302858, 102.45434471254349) zoomLevel:2 animated:NO];
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
    NSURL *url = [NSURL URLWithString:@"mapbox://examples.dwtmhwpu"];
    MGLVectorTileSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"weather-source" configurationURL:url];
    [style addSource:source];
    
    MGLFillStyleLayer *fillLayer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"weather-layer" source:source];
    fillLayer.sourceLayerIdentifier = @"201806261518";
    fillLayer.fillColor = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(value, %@, %@)", [UIColor clearColor], [self fillColors]];
    fillLayer.fillOpacity = [NSExpression expressionForConstantValue:@(0.7)];
    fillLayer.fillOutlineColor = [NSExpression expressionForConstantValue:[UIColor clearColor]];
    [style addLayer:fillLayer];
    
    self.radarLayer = fillLayer;
}

- (void)slideValueChanged:(UISlider *)silder event:(UIEvent *)event {
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
