#import "InsetMapExample.h"
@import Mapbox;

NSString *const MBXExampleInsetMap = @"InsetMapExample";

@interface InsetMapExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLMapView *miniMapView;
@end

@implementation InsetMapExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Set the main map's center coordinate and zoom level.
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(18.1096,-77.2975)
                zoomLevel:9
                 animated:NO];

    // Set inset mapview properties to create a smaller, non-interactive mapView that mimics the appearance of the main mapView.
    self.miniMapView = [[MGLMapView alloc] initWithFrame:CGRectZero];
    self.miniMapView.allowsScrolling = NO;
    self.miniMapView.allowsTilting = NO;
    self.miniMapView.allowsZooming = NO;
    self.miniMapView.rotateEnabled = NO;

    
    // we are only hiding the attribution within the second map view. Ordinarily, hiding the map view's attribution would be a violation of TOS, however, because the main map view still has its attribution, there is no issue here.
    [self.miniMapView.logoView setHidden:YES];
    [self.miniMapView.compassView setHidden: YES];
    self.miniMapView.attributionButton.tintColor = UIColor.clearColor;
    self.miniMapView.layer.borderColor = UIColor.blackColor.CGColor;
    self.miniMapView.layer.borderWidth = 1;
    
    [self.miniMapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel animated:NO];
    [self.miniMapView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Set the delegate property of our map view to self after instantiating it
    self.mapView.delegate = self;

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.miniMapView];
    [self installConstraints];

    
}

- (void)mapView:(MGLMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.miniMapView setCamera:self.mapView.camera animated:NO];
}


- (void)installConstraints {


    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        NSArray *constraints = @[
        [self.miniMapView.bottomAnchor constraintEqualToAnchor: safeArea.bottomAnchor constant:-40],
        [self.miniMapView.trailingAnchor constraintEqualToAnchor: safeArea.trailingAnchor constant:-15],
        [self.miniMapView.widthAnchor constraintEqualToAnchor:safeArea.widthAnchor multiplier:0.33],
        [self.miniMapView.heightAnchor constraintEqualToAnchor:self.miniMapView.widthAnchor]
        ];
    
        [NSLayoutConstraint activateConstraints:constraints];
    } else {
        self.miniMapView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
}

@end
