#import "UserTrackingModesExample.h"
@import Mapbox;

NSString *const MBXExampleUserTrackingModes = @"UserTrackingModesExample";

// Subclass UIButton to create a custom user tracking mode button
@interface UserLocationButton : UIButton
@property (nonatomic) CAShapeLayer *arrow;
@end

const CGFloat UserLocationButtonSize = 80;

@implementation UserLocationButton

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, UserLocationButtonSize, UserLocationButtonSize)];
    
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
        
        CAShapeLayer *arrow = [[CAShapeLayer alloc] init];
        
        arrow.path = [self arrowPath];
        arrow.lineWidth = 2;
        arrow.lineJoin = kCALineJoinRound;
        arrow.bounds = CGRectMake(0, 0, UserLocationButtonSize / 2, UserLocationButtonSize / 2);
        arrow.position = CGPointMake(UserLocationButtonSize / 2, UserLocationButtonSize / 2);
        arrow.shouldRasterize = YES;
        arrow.rasterizationScale = [[UIScreen mainScreen] scale];
        arrow.drawsAsynchronously = YES;

        _arrow = arrow;
        
        [self updateArrow:MGLUserTrackingModeNone];
        [self.layer addSublayer:_arrow];
    }
}

- (CGPathRef) arrowPath {
    
    CGFloat max = UserLocationButtonSize / 2;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:CGPointMake(max * 0.5, 0)];
    
    [bezierPath addLineToPoint:CGPointMake(max * 0.1, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, max * 0.65)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.9, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, 0)];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

-(void)updateArrow:(MGLUserTrackingMode)mode {
    CGColorRef arrowStrokeColor;
    CGPoint arrowPosition;
    CGColorRef arrowFillColor;
    CGFloat arrowRotation;
    
    switch (mode) {
        case MGLUserTrackingModeNone:
            arrowStrokeColor = [[UIColor whiteColor] CGColor];
            arrowPosition = CGPointMake(UserLocationButtonSize / 2, UserLocationButtonSize / 2);
            arrowFillColor = [[UIColor clearColor] CGColor];
            arrowRotation = 0;
            break;
        case MGLUserTrackingModeFollow:
            arrowStrokeColor = self.tintColor.CGColor;
            arrowPosition = CGPointMake(UserLocationButtonSize / 2 + 2, UserLocationButtonSize / 2 - 2);
            arrowFillColor = [[UIColor clearColor] CGColor];
            arrowRotation = 0.66;
            break;
        case MGLUserTrackingModeFollowWithHeading:
            arrowStrokeColor = [[UIColor clearColor] CGColor];
            arrowPosition = CGPointMake(UserLocationButtonSize / 2 + 2, UserLocationButtonSize / 2 - 2);
            arrowFillColor = self.tintColor.CGColor;
            arrowRotation = 0.66;
            break;
        case MGLUserTrackingModeFollowWithCourse:
            arrowStrokeColor = [[UIColor clearColor] CGColor];
            arrowPosition = CGPointMake(UserLocationButtonSize / 2, UserLocationButtonSize / 2);
            arrowFillColor = self.tintColor.CGColor;
            arrowRotation = 0;
            break;
    }
    
    [_arrow setFillColor:arrowFillColor];
    [_arrow setStrokeColor:arrowStrokeColor];
    [_arrow setAffineTransform:CGAffineTransformMakeRotation(arrowRotation)];
    
    [self layoutIfNeeded];
}

@end

@interface UserTrackingModesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UserLocationButton IBOutlet *button;

@end

@implementation UserTrackingModesExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle darkStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;

    self.mapView.tintColor = [UIColor redColor];
    self.mapView.attributionButton.tintColor = [UIColor lightGrayColor];

    [self.view addSubview:self.mapView];
    
    [self setupLocationButton];
}

- (void)mapView:(MGLMapView *)mapView didChangeUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated {
    [self.button updateArrow:mode];
}

-(void)locationButtonTapped:(UserLocationButton *)sender {
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
    }
    
//    _mapView.userTrackingMode = mode;
    [_mapView setUserTrackingMode:mode];
    
    NSLog(@"Mode: %lu", (unsigned long)mode); // this is changing to 1 on first press
    NSLog(@"Mode: %lu", (unsigned long)_mapView.userTrackingMode); // but this isn't changing
}

-(void)setupLocationButton {
    self.button = [[UserLocationButton alloc] init];
    [self.button addTarget:self action:@selector(locationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.button.tintColor = self.mapView.tintColor;
    [self.view addSubview:self.button];
    
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constraints = @[
        [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:10],
        [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10],
        [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.button.frame.size.height],
        [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.button.frame.size.width]
        
    ];
    
    [self.view addConstraints:constraints];
}

@end


