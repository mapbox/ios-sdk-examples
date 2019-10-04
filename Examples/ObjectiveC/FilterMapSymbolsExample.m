
#import "FilterMapSymbols.h"

NSString *const MBXExampleFilterMapSymbols = @"FilterMapSymbolsExample";

@import Mapbox;
@interface FilterMapSymbolsExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLSymbolStyleLayer *symbolLayer;
@property (nonatomic) MGLStyle *style;


@end


@implementation FilterMapSymbolsExample
 
- (void)viewDidLoad {
[super viewDidLoad];
    
 self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
 self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
 // Set the map's initial style, center coordinate, and zoom level
 self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/zizim/ck12h05if04ha1co4qr1ra9l2"];
 [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(38.897435, -77.039679)
 zoomLevel:11
 animated:NO];
    _mapView.delegate = self;
 [self.view addSubview:self.mapView];

    [self toggleSet];

}

-(void)toggleSet {
    // Create a UISegmentedControl to toggle between map styles
    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"theatre", @"bar", @"music", @"biking"]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.tintColor = [UIColor colorWithRed:0.976 green:0.843 blue:0.831 alpha:1];
    styleToggle.backgroundColor = [UIColor colorWithRed:0.09 green:0.568 blue:0.514 alpha:0.56];
    styleToggle.layer.cornerRadius = 4;
    styleToggle.clipsToBounds = YES;
    [self.view insertSubview:styleToggle aboveSubview:self.mapView];
    [styleToggle addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventValueChanged];
     
    // Configure autolayout constraints for the UISegmentedControl to align
    // at the bottom of the map view and above the Mapbox logo and attribution
    NSMutableArray *constraints = [NSMutableArray array];
     
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.logoView attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
     
    [self.view addConstraints:constraints];
}


- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {

 NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"iOS" ofType:@"geojson"]];
    
  
   MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"icons" URL:url options:@{}];
   [style addSource:source];
 
    self.symbolLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"icons" source:source];

// Create a stops dictionary with keys that are possible values for 'POITYPE', paired with icon images that will represent those features.
    NSDictionary *stops = @{
@"theatre": [NSExpression expressionForConstantValue:@"theatre-15"],
 @"bar": [NSExpression expressionForConstantValue:@"alcohol-shop-15"],
 @"music": [NSExpression expressionForConstantValue:@"music-15"],
 @"bicycle":[NSExpression expressionForConstantValue:@"bicycle-15"]
    };
 
// Use the stops dictionary to assign an icon based on the "icon" for each feature.
 self.symbolLayer.iconImageName = [NSExpression expressionWithFormat:@"FUNCTION(%@, 'valueForKeyPath:', icon)", stops];
    
    NSLog(@"%@", stops);
   
 
[style addLayer:_symbolLayer];
}

// Change the map style based on the selected index of the UISegmentedControl
- (void)changeStyle:(UISegmentedControl *)sender {
switch(sender.selectedSegmentIndex){
            case 0:
            NSLog(@"%@", @"ummm");

            self.symbolLayer.iconImageName = [NSExpression expressionForConstantValue:@"theatre-15"];
            self.symbolLayer.predicate = [NSPredicate predicateWithFormat:@"icon = 'theatre'"];

                    break;
            case 1:
            _symbolLayer.iconImageName =[NSExpression expressionForConstantValue:@"alcohol-shop-15"];
            _symbolLayer.predicate = [NSPredicate predicateWithFormat:@"icon = 'bar'"];
            break;
            case 2:
            _symbolLayer.iconImageName = [NSExpression expressionForConstantValue:@"music-15"];
            _symbolLayer.predicate =[NSPredicate predicateWithFormat:@"icon = 'music'"];
            break;
            case 3:
            _symbolLayer.iconImageName = [NSExpression expressionForConstantValue:@"bicycle-15"];
            _symbolLayer.predicate =[NSPredicate predicateWithFormat:@"icon = 'bicycle'"];
                    break;
            }
}

 
@end
