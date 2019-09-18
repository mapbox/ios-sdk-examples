#import "OrnamentsLayoutExample.h"

@import Mapbox;

// Ornament positions matrix arry, this example will demonstrate how ornament looks like in different positions.
NSString *const MBXExampleOrnamentsLayout = @"OrnamentsLayoutExample";
MGLOrnamentPosition ornamentPositions[4][4] = {
    {
        MGLOrnamentPositionTopLeft,
        MGLOrnamentPositionTopRight,
        MGLOrnamentPositionBottomRight,
        MGLOrnamentPositionBottomLeft
    },
    {
        MGLOrnamentPositionTopRight,
        MGLOrnamentPositionBottomRight,
        MGLOrnamentPositionBottomLeft,
        MGLOrnamentPositionTopLeft
    },
    {
        MGLOrnamentPositionBottomRight,
        MGLOrnamentPositionBottomLeft,
        MGLOrnamentPositionTopLeft,
        MGLOrnamentPositionTopRight
    },
    {
        MGLOrnamentPositionBottomLeft,
        MGLOrnamentPositionTopLeft,
        MGLOrnamentPositionTopRight,
        MGLOrnamentPositionBottomRight
    }
};

@interface OrnamentsLayoutExample ()<MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentPositionIndex;

@end

@implementation OrnamentsLayoutExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.915143, 116.404053)
                       zoomLevel:16
                       direction:30
                        animated:NO];
    mapView.delegate = self;
    mapView.showsScale = YES;
    [self.view addSubview:mapView];
    
    self.mapView = mapView;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // Stop the timer if the view was removed.
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Create a timer to update ornaments position every second.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(onTimerTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateOrnamentsPosition {
    // Get position matrix for current turn. We mod 4 to roll over the matrix array.
    MGLOrnamentPosition *currentPosition = ornamentPositions[_currentPositionIndex % 4];
    // Update ornaments position with position matrix.
    self.mapView.scaleBarPosition = currentPosition[0];
    self.mapView.compassViewPosition = currentPosition[1];
    self.mapView.logoViewPosition = currentPosition[2];
    self.mapView.attributionButtonPosition = currentPosition[3];
}

- (void)onTimerTick {
    self.currentPositionIndex ++;
    [self updateOrnamentsPosition];
}

@end
