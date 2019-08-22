#import "TextFormattingExample.h"
@import Mapbox;

NSString *const MBXExampleFormattingExpression = @"TextFormattingExample";

@interface TextFormattingExample ()

@property (nonatomic) MGLMapView *mapView;

@end

@implementation TextFormattingExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO: This is a test case, it should be changed to fulfill an ios example spec.
    self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.styleURL = [MGLStyle streetsStyleURL];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(36.374782, -119.620859)
                            zoomLevel:6
                             animated:NO];
    [self.view addSubview:self.mapView];
    
    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"Expression", @"JSON"]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.tintColor = [UIColor colorWithRed:0.976f green:0.843f blue:0.831f alpha:1];
    styleToggle.backgroundColor = [UIColor colorWithRed:0.973f green:0.329f blue:0.294f alpha:1];
    styleToggle.layer.cornerRadius = 4;
    styleToggle.clipsToBounds = YES;
    [self.view insertSubview:styleToggle aboveSubview:self.mapView];
    [styleToggle addTarget:self action:@selector(formatText:) forControlEvents:UIControlEventValueChanged];
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.logoView attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
    
    [self.view addConstraints:constraints];
}

// Format label's text based on the selected index of the UISegmentedControl
- (void)formatText:(UISegmentedControl *)sender {
    MGLSymbolStyleLayer *stateLayer = (MGLSymbolStyleLayer *)[self.mapView.style layerWithIdentifier:@"state-label"];
    NSExpression *expression = nil;
    switch(sender.selectedSegmentIndex){
        case 0: {
            MGLAttributedExpression *firstRowAttribute = [MGLAttributedExpression attributedExpression:[NSExpression expressionForKeyPath:@"name"]
                                                                                             fontNames:nil
                                                                                             fontScale:nil];
            MGLAttributedExpression *lineBreak = [MGLAttributedExpression attributedExpression:[NSExpression expressionForConstantValue:@"\n"]
                                                                                     fontNames:nil
                                                                                     fontScale:nil];
            NSExpression *fontNames = [NSExpression expressionForAggregate:@[ [NSExpression expressionForConstantValue:@"Arial Unicode MS Bold"] ]];
            MGLAttributedExpression *formatAttribute = [MGLAttributedExpression attributedExpression:[NSExpression expressionForKeyPath:@"name"]
                                                                                          attributes:@{ MGLFontScaleAttribute :
                                                                                                            [NSExpression expressionForConstantValue:@(0.8)],
                                                                                                        MGLFontColorAttribute :
                                                                                                            [NSExpression expressionForConstantValue:@"blue"],
                                                                                                        MGLFontNamesAttribute :
                                                                                                            fontNames
                                                                                                        }];
            
            NSExpression *attributedExpression = [NSExpression expressionWithFormat:@"mgl_attributed:(%@, %@, %@)",
                                                  [NSExpression expressionForConstantValue:firstRowAttribute],
                                                  [NSExpression expressionForConstantValue:lineBreak],
                                                  [NSExpression expressionForConstantValue:formatAttribute]
                                                  ];
            
            expression = [NSExpression expressionWithFormat:@"MGL_MATCH(2 - 1,  1, %@, 'Foo')", attributedExpression];
            
        }
            break;
        case 1: {
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"text-format" withExtension:@"json"];
            NSData *data = [NSData dataWithContentsOfURL:fileURL];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            expression = [NSExpression expressionWithMGLJSONObject:[json objectForKey:@"expression"]];
            
        }
            break;
    }
    stateLayer.text = expression;
}

@end
