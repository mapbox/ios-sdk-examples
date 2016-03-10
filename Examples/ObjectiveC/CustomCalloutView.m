//
//  CustomCalloutView.m
//  Examples
//
//  Created by Jason Wray on 3/6/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CustomCalloutView.h"

static CGFloat const tipHeight = 10.0;
static CGFloat const tipWidth = 20.0;

@interface CustomCalloutView ()

@property (strong, nonatomic) UIButton *callout;

@end

@implementation CustomCalloutView {
    id <MGLAnnotation> _representedObject;
    UIView *_leftAccessoryView;// unused
    UIView *_rightAccessoryView;// unused
    __weak id <MGLCalloutViewDelegate> _delegate;
}

@synthesize representedObject = _representedObject;
@synthesize leftAccessoryView = _leftAccessoryView;
@synthesize rightAccessoryView = _rightAccessoryView;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        _callout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _callout.backgroundColor = [self colorForCallout];
        _callout.tintColor = [UIColor blackColor];
        _callout.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        _callout.layer.cornerRadius = 4.0;

        [self addSubview:_callout];
    }

    return self;
}


#pragma mark - API

- (void)presentCalloutFromRect:(CGRect)rect inView:(UIView *)view constrainedToView:(UIView *)constrainedView animated:(BOOL)animated
{
    // do not show a callout if there is no title set for the annotation
    if (![self.representedObject respondsToSelector:@selector(title)])
    {
        return;
    }

    [view addSubview:self];

    // prepare title label
    [self.callout setTitle:self.representedObject.title forState:UIControlStateNormal];
    [self.callout sizeToFit];

    // handle taps and eventually try to send them to the delegate (usually the map view)
    if ([self isCalloutTappable])
    {
        [_callout addTarget:self action:@selector(calloutTapped) forControlEvents:UIControlEventTouchUpInside];
    }

    // prepare our frame, adding extra space at the bottom for the tip
    CGFloat frameWidth = self.callout.bounds.size.width;
    CGFloat frameHeight = self.callout.bounds.size.height + tipHeight;
    CGFloat frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0);
    CGFloat frameOriginY = rect.origin.y - frameHeight;
    self.frame = CGRectMake(frameOriginX, frameOriginY,
                            frameWidth, frameHeight);

    if (animated)
    {
        self.alpha = 0.0;

        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        } completion:nil];
    }
}

- (void)dismissCalloutAnimated:(BOOL)animated
{
    if (self.superview)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
}

- (BOOL)isCalloutTappable
{
    return [self.delegate respondsToSelector:@selector(calloutViewTapped:)];
}

- (void)calloutTapped
{
    if ([self isCalloutTappable])
    {
        [self.delegate performSelector:@selector(calloutViewTapped:) withObject:self];
    }
}

- (UIColor *)colorForCallout
{
    return [UIColor whiteColor];
}

#pragma mark - internals

- (void)drawRect:(CGRect)rect
{
    // draw the white tip at the bottom
    UIColor *fillColor = [self colorForCallout];

    CGFloat tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0);
    CGPoint tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y +rect.size.height);
    CGFloat heightWithoutTip = rect.size.height - tipHeight;

    CGContextRef ctxt = UIGraphicsGetCurrentContext();

    CGMutablePathRef tipPath = CGPathCreateMutable();
    CGPathMoveToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipBottom.x, tipBottom.y);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft + tipWidth, heightWithoutTip);
    CGPathCloseSubpath(tipPath);

    [fillColor setFill];
    CGContextAddPath(ctxt, tipPath);
    CGContextFillPath(ctxt);
    CGPathRelease(tipPath);
}

@end
