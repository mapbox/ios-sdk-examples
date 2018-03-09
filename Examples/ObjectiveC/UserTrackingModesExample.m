#import "UserTrackingModesExample.h"
@import Mapbox;

NSString *const MBXExampleUserTrackingModes = @"UserTrackingModesExample";

#pragma mark - UIButton subclass

// Subclass UIButton to create a custom user tracking mode button
@interface UserLocationButton : UIButton
@property (nonatomic) CAShapeLayer *arrow;
@property (nonatomic) CGFloat buttonSize;
@end

@implementation UserLocationButton

- (instancetype)initWithButtonSize:(CGFloat)buttonSize {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, buttonSize, buttonSize);
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.layer.cornerRadius = 4;
        self.buttonSize = buttonSize;
        
        CAShapeLayer *arrow = [[CAShapeLayer alloc] init];
        
        arrow.path = [self arrowPath];
        arrow.lineWidth = 2;
        arrow.lineJoin = kCALineJoinRound;
        arrow.bounds = CGRectMake(0, 0, buttonSize / 2, buttonSize / 2);
        arrow.position = CGPointMake(buttonSize / 2, buttonSize / 2);
        arrow.shouldRasterize = YES;
        arrow.rasterizationScale = [[UIScreen mainScreen] scale];
        arrow.drawsAsynchronously = YES;
        
        self.arrow = arrow;
        
        [self updateArrowForTrackingMode:MGLUserTrackingModeNone];
        
        [self.layer addSublayer:self.arrow];
    }
    
    return self;
}

- (CGPathRef) arrowPath {
    
    CGFloat max = self.buttonSize / 2;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    [bezierPath moveToPoint:CGPointMake(max * 0.5, 0)];
    
    [bezierPath addLineToPoint:CGPointMake(max * 0.1, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, max * 0.65)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.9, max)];
    [bezierPath addLineToPoint:CGPointMake(max * 0.5, 0)];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

-(void) updateArrowForTrackingMode:(MGLUserTrackingMode)mode {
    
    UIColor *activePrimaryColor = UIColor.redColor;
    UIColor *disabledPrimaryColor = UIColor.clearColor;
    UIColor *disabledSecondaryColor = UIColor.whiteColor;
    CGFloat rotatedArrow = 0.66;
    
    switch (mode) {
        case MGLUserTrackingModeNone:
            [self updateArrowFillColor:disabledPrimaryColor
                           strokeColor:disabledSecondaryColor
                              rotation:0];
            break;
        case MGLUserTrackingModeFollow:
            [self updateArrowFillColor:disabledPrimaryColor
                           strokeColor:activePrimaryColor
                              rotation:0];
            break;
        case MGLUserTrackingModeFollowWithHeading:
            [self updateArrowFillColor:activePrimaryColor
                           strokeColor:activePrimaryColor
                              rotation:rotatedArrow];
            break;
        case MGLUserTrackingModeFollowWithCourse:
            [self updateArrowFillColor:activePrimaryColor
                           strokeColor:activePrimaryColor
                              rotation:0];
            break;
    }
}

-(void) updateArrowFillColor:(UIColor*)fillColor strokeColor:(UIColor*) strokeColor rotation:(CGFloat) rotation {
    [self.arrow setFillColor:fillColor.CGColor];
    [self.arrow setStrokeColor:strokeColor.CGColor];
    [self.arrow setAffineTransform:CGAffineTransformMakeRotation(rotation)];
    
    [self layoutIfNeeded];
}

@end

#pragma mark - ViewController

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

    // The user location annotation takes its color from the map view's tint color.
    self.mapView.tintColor = [UIColor redColor];
    self.mapView.attributionButton.tintColor = [UIColor lightGrayColor];

    [self.view addSubview:self.mapView];
    
    [self setupLocationButton];
    self.mapView.userTrackingMode = MGLUserTrackingModeNone;
}

-(void)locationButtonTapped:(UserLocationButton *)sender {
    MGLUserTrackingMode mode;
    
    switch (self.mapView.userTrackingMode) {
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

    [self.mapView setUserTrackingMode:mode];
    [sender updateArrowForTrackingMode:mode];
}

-(void)setupLocationButton {
    self.button = [[UserLocationButton alloc] initWithButtonSize:80];
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


