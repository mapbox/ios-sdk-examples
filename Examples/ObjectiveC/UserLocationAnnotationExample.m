#import "UserLocationAnnotationExample.h"

@import Mapbox;

NSString *const MBXExampleUserLocationAnnotation = @"UserLocationAnnotationExample";

// Create subclass of MGLUserLocationAnnotationView. This is used to create a custom user location annotation.

@interface CustomUserLocationAnnotationView : MGLUserLocationAnnotationView

@property (nonatomic) CGFloat size;
@property (nonatomic) CGFloat arrowSize;

@property (nonatomic) CALayer *dot;
@property (nonatomic) CAShapeLayer *arrow;

@end

@implementation CustomUserLocationAnnotationView

- (instancetype)init {
    self.size = 25;
    self = [super initWithFrame:CGRectMake(0, 0, self.size, self.size)];
    
    return self;
}

// -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed.
- (void)update {
    // This method can be called many times a second, so be careful to keep it lightweight.
    if (CLLocationCoordinate2DIsValid(self.userLocation.coordinate)) {
        [self setupLayers];
        [self updateHeading];
    }
}

- (void)updateHeading {

    // Show the heading arrow, if the heading of the user is being tracked.
    if (self.userLocation.heading && self.mapView.userTrackingMode == MGLUserTrackingModeFollowWithHeading) {
        _arrow.hidden = NO;
        
        // Rotate the arrow according to the user’s heading.
        CGAffineTransform rotation = CGAffineTransformRotate(
                                        CGAffineTransformIdentity,
                                        -MGLRadiansFromDegrees(self.mapView.direction - self.userLocation.heading.trueHeading));
        [self.layer setAffineTransform:rotation];
    } else {
        _arrow.hidden = YES;
    }
}

- (void)setupLayers {
    [self setupDot];
    [self setupArrow];
}

- (void)setupDot {
    if (!_dot) {
        _dot = [CALayer layer];
        _dot.bounds = CGRectMake(0, 0, _size, _size);
        _dot.position = CGPointMake(_size / 2, _size / 2);
        
        // Use CALayer’s corner radius to turn this layer into a circle.
        _dot.cornerRadius = _size / 2;
        _dot.backgroundColor = super.tintColor.CGColor;
        _dot.borderWidth = 2;
        _dot.borderColor = [UIColor whiteColor].CGColor;
        _dot.shadowColor = [UIColor blackColor].CGColor;
        _dot.shadowOffset = CGSizeMake(0, 0);
        
        [self.layer addSublayer:_dot];
    }
}

- (void)setupArrow {
    if (!_arrow) {
        _arrowSize = _size / 2.5;
        
        _arrow = [CAShapeLayer layer];
        _arrow.path = [self arrowPath];
        _arrow.frame = CGRectMake(0, 0, _arrowSize, _arrowSize);
        _arrow.position = CGPointMake(_size / 2, _size / -4.5);
        _arrow.fillColor = super.tintColor.CGColor;
//        _arrow.shouldRasterize = YES;
//        _arrow.drawsAsynchronously = YES;
        [self.layer addSublayer:_arrow];
    }
}

- (CGPathRef)arrowPath {
    // Draw an arrow.

    CGFloat max = _arrowSize;
    
    CGPoint top = CGPointMake(max * 0.5, max * 0.4);
    CGPoint left = CGPointMake(0, max);
    CGPoint right = CGPointMake(max, max);
    CGPoint center = CGPointMake(max * 0.5, max * 0.8);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:top];
    [bezierPath addLineToPoint:left];
    [bezierPath addQuadCurveToPoint:right controlPoint:center];
    [bezierPath addLineToPoint:top];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

@end

@interface UserLocationAnnotationExample () <MGLMapViewDelegate>
@end

@implementation UserLocationAnnotationExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
    // Enable heading tracking mode so that the arrow will appear.
    mapView.userTrackingMode = MGLUserTrackingModeFollowWithHeading;
    
    [self.view addSubview:mapView];
}

// MARK: - MGLMapViewDelegate methods

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    
    // Substitute a custom view for the user location annotation.
    if ([annotation isKindOfClass:[MGLUserLocation class]]) {
        return [[CustomUserLocationAnnotationView alloc] init];
    }
    
    return nil;
}

@end
