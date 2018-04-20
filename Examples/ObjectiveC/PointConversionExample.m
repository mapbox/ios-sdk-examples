#import "PointConversionExample.h"
@import Mapbox;

NSString *const MBXExamplePointConversion = @"PointConversionExample";

@interface PointConversionExample ()
@property (nonatomic) MGLMapView *mapView;
@end

@implementation PointConversionExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];

    // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [singleTap requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:singleTap];

    // Convert `mapView.centerCoordinate` (CLLocationCoordinate2D) to screen location (CGPoint).
    CGPoint centerScreenPoint = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:nil];
    NSLog(@"Screen center: %@ = %@", NSStringFromCGPoint(centerScreenPoint), NSStringFromCGPoint(self.mapView.center));
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
    CGPoint tapPoint = [tap locationInView:self.mapView];
    CLLocationCoordinate2D tapCoordinate = [self.mapView convertPoint:tapPoint toCoordinateFromView:nil];
    NSLog(@"You tapped at: %.5f, %.5f", tapCoordinate.latitude, tapCoordinate.longitude);

    // Create an array of coordinates for our polyline, starting at the center of the map and ending at the tap coordinate.
    CLLocationCoordinate2D coordinates[] = { self.mapView.centerCoordinate, tapCoordinate };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);

    // Remove any existing polyline(s) from the map.
    if (self.mapView.annotations.count) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    // Add a polyline with the new coordinates.
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:numberOfCoordinates];
    [self.mapView addAnnotation:polyline];
}

@end
