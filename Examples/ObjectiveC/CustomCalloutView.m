//
//  CustomCalloutView.m
//  Examples
//
//  Created by Jason Wray on 3/6/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "CustomCalloutView.h"

static CGFloat const tipHeight = 10.0;
static CGFloat const tipWidth = 10.0;

@interface CustomCalloutView ()

@property (strong, nonatomic) UILabel *mainLabel;

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
        _mainLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _mainLabel.backgroundColor = [UIColor clearColor];

        [self addSubview: _mainLabel];
    }
    return self;
}


#pragma mark - API

- (void)presentCalloutFromRect:(CGRect)rect inView:(UIView *)view constrainedToView:(UIView *)constrainedView animated:(BOOL)animated
{
    self.alpha = 0.0;

    [view addSubview:self];

    // prepare title label
    if ([self.representedObject respondsToSelector:@selector(title)])
    {
        self.mainLabel.text = self.representedObject.title;
        [self.mainLabel sizeToFit];
    }

    // prepare our frame
    CGFloat frameWidth = self.mainLabel.bounds.size.width;
    CGFloat frameHeight = self.mainLabel.bounds.size.height * 2.0;
    CGFloat frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0);
    CGFloat frameOriginY = rect.origin.y - frameHeight;
    self.frame = CGRectMake(frameOriginX, frameOriginY,
                            frameWidth, frameHeight);

    // show the callout view
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        } completion:nil];
    }
    else
    {
        self.alpha = 1.0;
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

#pragma mark - internals

- (void)drawRect:(CGRect)rect
{
    UIColor *fillColor = [UIColor colorWithWhite:1.0 alpha:1.0];

    CGFloat tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0);
    CGPoint tipBottom = CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y +rect.size.height);
    CGFloat heightWithoutTip = rect.size.height - tipHeight;

    // draw the white background with tip
    CGContextRef ctxt = UIGraphicsGetCurrentContext();

    CGMutablePathRef tipPath = CGPathCreateMutable();
    CGPathMoveToPoint(tipPath, NULL, 0, 0);
    CGPathAddLineToPoint(tipPath, NULL, 0, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipBottom.x, tipBottom.y);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft + tipWidth, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, CGRectGetWidth(rect), heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, CGRectGetWidth(rect), 0);
    CGPathCloseSubpath(tipPath);

    [fillColor setFill];
    CGContextAddPath(ctxt, tipPath);
    CGContextFillPath(ctxt);
    CGPathRelease(tipPath);
}

@end
