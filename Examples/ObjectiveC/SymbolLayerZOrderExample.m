#import "SymbolLayerZOrderExample.h"
@import Mapbox;

NSString *const MBXExampleSymbolLayerZOrder = @"SymbolLayerZOrderExample";

@interface SymbolLayerZOrderExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLSymbolStyleLayer *layer;

@end

@implementation SymbolLayerZOrderExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new map view using the Mapbox Light style.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                            styleURL:[MGLStyle lightStyleURL]];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.tintColor = [UIColor darkGrayColor];
    
    // Set the map’s center coordinate and zoom level.
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(-41.292650,174.778768);
    self.mapView.zoomLevel = 11.5;
    
    self.mapView.delegate = self;
    [self.view addSubview: self.mapView];
}

// Wait until the style is loaded before modifying the map style.
- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    // Add icons to the map's style.
    // Note that adding icons to the map's style does not mean they have
    // been added to the map yet.
    [style setImage:([UIImage imageNamed:@"yellow-triangle-image"]) forName:@"yellow-triangle"];
    [style setImage:([UIImage imageNamed:@"green-triangle-image"]) forName:@"green-triangle"];
    [style setImage:([UIImage imageNamed:@"purple-triangle-image"]) forName:@"purple-triangle"];

    MGLPointFeature *yellow = [MGLPointFeature alloc];
    yellow.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    yellow.attributes = @{@"id": @"yellow-triangle"};

    MGLPointFeature *green = [MGLPointFeature alloc];
    green.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    green.attributes = @{@"id": @"green-triangle"};

    MGLPointFeature *purple = [MGLPointFeature alloc];
    purple.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    purple.attributes = @{@"id": @"purple-triangle"};

    MGLShapeCollectionFeature *shapeCollection = [MGLShapeCollectionFeature shapeCollectionWithShapes:@[yellow, green, purple]];
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"symbol-layer-z-order-example" shape:shapeCollection options:nil];

    [style addSource:source];
    self.layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"points-style" source:source];
    self.layer.sourceLayerIdentifier = @"symbol-layer-z-order-example";
    // Create a stops dictionary with keys that are possible values for 'id', paired with icon images that will represent those features.
    NSDictionary *icons = @{
        @"yellow-triangle": @"yellow-triangle",
        @"green-triangle": @"green-triangle",
        @"purple-triangle": @"purple-triangle"};
    // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
    self.layer.iconImageName = [NSExpression expressionWithFormat:@"FUNCTION(%@, 'valueForKeyPath:', id)", icons];
    self.layer.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
    self.layer.symbolZOrder = [NSExpression expressionForConstantValue:@"source"];
    [style addLayer:self.layer];

    [self addToggleButton];
}

- (void)addToggleButton {
    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"viewport-y", @"source"]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.backgroundColor = [UIColor colorWithRed:0.83 green:0.84 blue:0.95 alpha:1.0];
    styleToggle.tintColor = [UIColor colorWithRed:0.26 green:0.39 blue:0.98 alpha:1.0];
    styleToggle.layer.cornerRadius = 4;
    styleToggle.clipsToBounds = YES;
    styleToggle.selectedSegmentIndex = 1;
    [self.view insertSubview:styleToggle aboveSubview:self.mapView];
    [styleToggle addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventValueChanged];

    // Configure autolayout constraints for the UISegmentedControl to align
    // at the bottom of the map view and above the Mapbox logo and attribution
    NSMutableArray *constraints = [NSMutableArray array];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.logoView attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];

    [self.view addConstraints:constraints];
}

// Change the map style based on the selected index of the UISegmentedControl
- (void)changeStyle:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            self.layer.symbolZOrder = [NSExpression expressionForConstantValue:@"viewport-y"];
            break;
        case 1:
            self.layer.symbolZOrder = [NSExpression expressionForConstantValue:@"source"];;
            break;
    }
}
@end
