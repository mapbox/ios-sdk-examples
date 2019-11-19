#import "RasterImageryExample.h"
@import Mapbox;

NSString *const MBXExampleRasterImagery = @"RasterImageryExample";

@interface RasterImageryExample () <MGLMapViewDelegate>
@property (nonatomic) MGLRasterStyleLayer *rasterLayer;
@property (nonatomic) MGLMapView *mapView;
@end

@implementation RasterImageryExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5188, -122.6748)
		       zoomLevel:13
			animated:NO];

    self.mapView.delegate = self;

    [self.view addSubview:self.mapView];

    // Add a UISlider that will control the raster layer’s opacity.
    [self addSlider];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add a new raster source and layer.
    MGLRasterTileSource *source = [[MGLRasterTileSource alloc] initWithIdentifier:@"stamen-watercolor"
        tileURLTemplates:@[@"https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg"]
        options:@{ MGLTileSourceOptionTileSize: @256}];
    MGLRasterStyleLayer *rasterLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"stamen-watercolor" source:source];

    [mapView.style addSource:source];
    [mapView.style addLayer:rasterLayer];

    self.rasterLayer = rasterLayer;
}

- (void)updateLayerOpacity:(UISlider *)sender {
    [self.rasterLayer setRasterOpacity:[NSExpression expressionForConstantValue:@(sender.value)]];
}

- (void)addSlider {
    CGFloat padding = 10.0;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(padding, self.view.frame.size.height - 44 - 30, self.view.frame.size.width - padding * 2, 44)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value = 1;
    slider.continuous = false;
    [slider addTarget:self action:@selector(updateLayerOpacity:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *constraints = @[
          [slider.bottomAnchor constraintEqualToAnchor: safeArea.bottomAnchor constant:-self.mapView.logoView.bounds.size.height - 10],
          [slider.widthAnchor constraintEqualToConstant:self.view.frame.size.width - padding * 2],
          [slider.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor]
        ];

        [NSLayoutConstraint activateConstraints:constraints];
    } else {
            slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
}

@end
