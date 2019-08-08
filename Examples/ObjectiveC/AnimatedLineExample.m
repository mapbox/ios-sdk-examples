#import "AnimatedLineExample.h"
@import Mapbox;

NSString *const MBXExampleAnimatedLine = @"AnimatedLineExample";

@interface AnimatedLineExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLShapeSource *polylineSource;
@property (nonatomic) NSArray<CLLocation *> *locations;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AnimatedLineExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;

    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736)
                            zoomLevel:11
                             animated:NO];

    [self.view addSubview:self.mapView];

}

// Wait until the map is loaded before adding to the map.
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
    [self addPolylineToStyle:mapView.style];
    [self animatePolyline];
}

- (void)addPolylineToStyle:(MGLStyle *)style {
    // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"polyline" features:@[] options:nil];
    [style addSource:source];
    self.polylineSource = source;
    
    // Add a layer to style our polyline.
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"polyline" source:source];
    layer.lineJoin = [NSExpression expressionForConstantValue:@"round"];
    layer.lineCap = layer.lineJoin = [NSExpression expressionForConstantValue:@"round"];
    layer.lineColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
    
    // The line width should gradually increase based on the zoom level.
    layer.lineWidth = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                       @{@14: @5, @18: @20}];
    [self.mapView.style addLayer:layer];
}

- (void)animatePolyline {
    self.currentIndex = 1;

    // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(NSTimer*)timer {
    if (self.currentIndex > self.locations.count) {
        [self.timer invalidate];
        return;
    }

    // Create a subarray of locations up to the current index.
    NSArray *currentLocations = [self.locations subarrayWithRange:NSMakeRange(0, _currentIndex)];

    // Update our MGLShapeSource with the current locations.
    [self updatePolylineWithLocations:currentLocations];

    self.currentIndex++;
}

- (void)updatePolylineWithLocations:(NSArray<CLLocation *> *)locations {
    CLLocationCoordinate2D coordinates[locations.count];

    for (NSUInteger i = 0; i < locations.count; i++) {
        coordinates[i] = locations[i].coordinate;
    }

    MGLPolylineFeature *polyline = [MGLPolylineFeature polylineWithCoordinates:coordinates count:locations.count];

    // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
    self.polylineSource.shape = polyline;
}

- (NSArray<CLLocation *> *)locations {
    NSArray *coordinates = @[
        @[@(-122.63748), @45.52214],
        @[@(-122.64855), @45.52218],
        @[@(-122.6545), @45.52219],
        @[@(-122.65497), @45.52196],
        @[@(-122.65631), @45.52104],
        @[@(-122.6578), @45.51935],
        @[@(-122.65867), @45.51848],
        @[@(-122.65872), @45.51293],
        @[@(-122.66576), @45.51295],
        @[@(-122.66745), @45.51252],
        @[@(-122.66813), @45.51244],
        @[@(-122.67359), @45.51385],
        @[@(-122.67415), @45.51406],
        @[@(-122.67481), @45.51484],
        @[@(-122.676), @45.51532],
        @[@(-122.68106), @45.51668],
        @[@(-122.68503), @45.50934],
        @[@(-122.68546), @45.50858],
        @[@(-122.6852), @45.50783],
        @[@(-122.68424), @45.50714],
        @[@(-122.68433), @45.50585],
        @[@(-122.68429), @45.50521],
        @[@(-122.68456), @45.50445],
        @[@(-122.68538), @45.50371],
        @[@(-122.68653), @45.50311],
        @[@(-122.68731), @45.50292],
        @[@(-122.68742), @45.50253],
        @[@(-122.6867), @45.50239],
        @[@(-122.68545), @45.5026],
        @[@(-122.68407), @45.50294],
        @[@(-122.68357), @45.50271],
        @[@(-122.68236), @45.50055],
        @[@(-122.68233), @45.49994],
        @[@(-122.68267), @45.49955],
        @[@(-122.68257), @45.49919],
        @[@(-122.68376), @45.49842],
        @[@(-122.68428), @45.49821],
        @[@(-122.68573), @45.49798],
        @[@(-122.68923), @45.49805],
        @[@(-122.68926), @45.49857],
        @[@(-122.68814), @45.49911],
        @[@(-122.68865), @45.49921],
        @[@(-122.6897), @45.49905],
        @[@(-122.69346), @45.49917],
        @[@(-122.69404), @45.49902],
        @[@(-122.69438), @45.49796],
        @[@(-122.69504), @45.49697],
        @[@(-122.69624), @45.49661],
        @[@(-122.69781), @45.4955],
        @[@(-122.69803), @45.49517],
        @[@(-122.69711), @45.49508],
        @[@(-122.69688), @45.4948],
        @[@(-122.69744), @45.49368],
        @[@(-122.69702), @45.49311],
        @[@(-122.69665), @45.49294],
        @[@(-122.69788), @45.49212],
        @[@(-122.69771), @45.49264],
        @[@(-122.69835), @45.49332],
        @[@(-122.7007), @45.49334],
        @[@(-122.70167), @45.49358],
        @[@(-122.70215), @45.49401],
        @[@(-122.70229), @45.49439],
        @[@(-122.70185), @45.49566],
        @[@(-122.70215), @45.49635],
        @[@(-122.70346), @45.49674],
        @[@(-122.70517), @45.49758],
        @[@(-122.70614), @45.49736],
        @[@(-122.70663), @45.49736],
        @[@(-122.70807), @45.49767],
        @[@(-122.70807), @45.49798],
        @[@(-122.70717), @45.49798],
        @[@(-122.70713), @45.4984],
        @[@(-122.70774), @45.49893],
    ];

    NSMutableArray<CLLocation *> *locations = [NSMutableArray array];
    for (NSArray<NSNumber *> *c in coordinates) {
        [locations addObject:[[CLLocation alloc] initWithLatitude:[c[1] doubleValue] longitude:[c[0] doubleValue]]];
    }
    return locations;
}

@end
