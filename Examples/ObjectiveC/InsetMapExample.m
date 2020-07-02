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

    // Set the delegate property of our map view to self after instantiating it.
    self.mapView.delegate = self;
    
    // Set the main map view's center coordinate and zoom level.
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(
        18.1096,-77.2975) zoomLevel:9 animated:NO];

    /**
     Set inset map view properties to create a smaller,
     non-interactive map view that mimics the appearance of the main map view.
     */
    self.miniMapView = [[MGLMapView alloc] initWithFrame:CGRectZero];
    self.miniMapView.allowsScrolling = NO;
    self.miniMapView.allowsTilting = NO;
    self.miniMapView.allowsZooming = NO;
    self.miniMapView.rotateEnabled = NO;
    
    /**
     Hiding the map view's attribution goes against our attribution requirements.
     However, because the main map view still has attribution, hiding the
     attribution for the mini map view in this case is acceptable.

     For more information, please refer to our attribution guidelines:
     https://docs.mapbox.com/help/how-mapbox-works/attribution/
    */
    self.miniMapView.logoView.hidden = YES;
    self.miniMapView.compassView.hidden = YES;
    self.miniMapView.attributionButton.tintColor = UIColor.clearColor;
    self.miniMapView.layer.borderColor = UIColor.blackColor.CGColor;
    self.miniMapView.layer.borderWidth = 1;
    
    /** Setting mini map view zoom level to 2 zoom levels below the main map view to showcase
     one use case for an inset map.
     */
    [self.miniMapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel - 2 animated:NO];
    [self.miniMapView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.miniMapView];
    [self installConstraints];
}

/**
 Set the mini map view's camera to the map view camera so while the region is changing on the
 map view, the same camera changes are made in the mini map view.
*/
- (void)mapViewRegionIsChanging:(MGLMapView *)mapView{
   [self.miniMapView setCenterCoordinate:self.mapView.centerCoordinate zoomLevel:self.mapView.zoomLevel-2 animated:NO];
}

- (void)installConstraints {
    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        NSArray *constraints = @[
        [self.miniMapView.bottomAnchor constraintEqualToAnchor:
         safeArea.bottomAnchor constant:-40],
        [self.miniMapView.trailingAnchor constraintEqualToAnchor:
         safeArea.trailingAnchor constant:-15],
        [self.miniMapView.widthAnchor constraintEqualToAnchor:
         safeArea.widthAnchor multiplier:0.33],
        [self.miniMapView.heightAnchor constraintEqualToAnchor:
         self.miniMapView.widthAnchor]
        ];
    
        [NSLayoutConstraint activateConstraints:constraints];
    } else {
        self.miniMapView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin;
    }
}

@end
