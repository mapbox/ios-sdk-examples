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
    // Set the map's center coordinate
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(59.31, 18.06)
                zoomLevel:9
                 animated:NO];
    
    self.miniMapView = [[MGLMapView alloc] initWithFrame:CGRectZero];
    [self.miniMapView setAllowsScrolling:NO];
    [self.miniMapView setAllowsTilting:NO];
    [self.miniMapView setAllowsZooming:NO];
    [self.miniMapView setAllowsRotating:NO];

    [self.miniMapView.logoView setHidden:YES];
    self.miniMapView.attributionButton.tintColor = UIColor.clearColor;
     UIColor *black = [UIColor blackColor];
    [self.miniMapView.layer setBorderColor: black.CGColor];
    [self.miniMapView.layer setBorderWidth:1];
    
    [self.miniMapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel animated:NO];
    [self.miniMapView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Set the delegate property of our map view to self after instantiating it
    self.mapView.delegate = self;

    [self.view addSubview:self.mapView];
    [self.view addSubview:_miniMapView];
    [self installConstraints];

    
}

- (void)mapView:(MGLMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.miniMapView setCamera:self.mapView.camera animated:NO
     ];}


- (void)installConstraints {


    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        NSArray *constraints = @[
        [self.miniMapView.bottomAnchor constraintEqualToAnchor: safeArea.bottomAnchor constant:-35],
        [self.miniMapView.trailingAnchor constraintEqualToAnchor: safeArea.trailingAnchor constant:-10],
        [self.miniMapView.widthAnchor constraintEqualToAnchor:_mapView.widthAnchor multiplier:0.33],
        [self.miniMapView.heightAnchor constraintEqualToAnchor:_miniMapView.widthAnchor]
        ];
    
        [NSLayoutConstraint activateConstraints:constraints];
    } else {
        self.miniMapView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
}

@end
