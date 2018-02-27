#import "UserTrackingModesExample.h"
@import Mapbox;

NSString *const MBXExampleUserTrackingModes = @"UserTrackingModesExample";

@interface UserTrackingModesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIButton IBOutlet *button;

@end

@implementation UserTrackingModesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
//    mapView.userTrackingMode = MGLUserTrackingModeFollowWithHeading;

    mapView.tintColor = [UIColor redColor];
    mapView.attributionButton.tintColor = [UIColor lightGrayColor];

    [self.view addSubview:mapView];
}

- (void)mapView:(MGLMapView *)mapView didChangeUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated {
    // button.updateArrow(for:mode)
}

-(void)locationButtonTapped:(UIButton *)sender {
    MGLUserTrackingMode mode;
    
    switch (_mapView.userTrackingMode) {
        case MGLUserTrackingModeNone:
            mode = MGLUserTrackingModeFollow;
            break;
        case MGLUserTrackingModeFollow:
            mode = MGLUserTrackingModeFollowWithHeading;
            break;
        case MGLUserTrackingModeFollowWithHeading:
            mode = MGLUserTrackingModeFollowWithCourse;
            break;
        case MGLUserTrackingModeFollowWithCourse:
            mode = MGLUserTrackingModeNone;
            break;
        default:
            mode = MGLUserTrackingModeNone;
            break;
    }
    
    _mapView.userTrackingMode = mode;
}

-(void)setupLocationButton {
    // Finish setting up button and constraints here
}

@end

// Custom class to override UIButton

@interface UserLocationButton : UIButton
@property (nonatomic) CGFloat size;
@property (nonatomic) CAShapeLayer *arrow;
@end

@implementation UserLocationButton

-(CGFloat) size
{
    return 80;
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, self.size, self.size)];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.layer.cornerRadius = 4;
    
    [self layoutArrow];
}

- (void)layoutArrow {
    if (_arrow == nil) {
        CAShapeLayer *arrow;
        
        arrow.path = arrowPath;
        arrow.lineWidth = 2;
        arrow.lineJoin = kCALineJoinRound;
        arrow.bounds = CGRectMake(0, 0, _size / 2, _size / 2);
        arrow.position = CGPointMake(_size / 2, _size / 2);
        arrow.shouldRasterize = YES;
        arrow.rasterizationScale = [[UIScreen mainScreen] scale];
        arrow.drawsAsynchronously = YES;
        
        _arrow = arrow;
        [updateArrow:MGLUserTrackingModeNone];
        [self.layer addSublayer:_arrow];
    }
}

- (CGPathRef) arrowPath {
    CGFloat max = _size / 2;
    
    UIBezierPath *bezierPath;
    [bezierPath moveToPoint:CGPointMake(max * 0.5, 0)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.1, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, max * 0.65)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.9, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, 0)];
    
    return bezierPath.CGPath;
}

-(void)updateArrow:(MGLUserTrackingMode)mode {
    struct CGColor *stroke;
    
    switch (mode) {
        case MGLUserTrackingModeNone:
            stroke = [[UIColor.whiteColor] CGColorRef];
            break;
        case MGLUserTrackingModeFollow:
            stroke = [tintColor cgColor];
            break;
        case MGLUserTrackingModeFollowWithHeading, MGLUserTrackingModeFollowWithCourse:
            stroke = [[UIColor.clearColor] CGColorRef];
            break;
        default:
            break;
    }
    
    _arrow.strokeColor = stroke;
    
    // This...needs work
    if (_arrow.position = mode == MGLUserTrackingModeNone || mode == MGLUserTrackingModeFollowWithCourse) {
        <#statements#>
    } else {
        
    }
}

@end


