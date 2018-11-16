//
//  SymbolLayerZOrderExample.m
//  Examples
//
//  Created by Sam Fader on 10/15/18.
//  Copyright © 2018 Mapbox. All rights reserved.
//

#import "SymbolLayerZOrderExample.h"
@import Mapbox;

NSString *const MBXExampleSymbolLayerZOrder = @"SymbolLayerZOrderExample";

@interface SymbolLayerZOrderExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

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
    [style setImage:([UIImage imageNamed:@"oval"]) forName:@"oval"];
    [style setImage:([UIImage imageNamed:@"squircle"]) forName:@"squircle"];
    [style setImage:([UIImage imageNamed:@"star"]) forName:@"star"];
//    style.setImage(UIImage(named: "oval")!, forName: "oval")
//    style.setImage(UIImage(named: "squircle")!, forName: "squircle")
//    style.setImage(UIImage(named: "star")!, forName: "star")
//
    MGLPointFeature *feature1 = [MGLPointFeature alloc];
    feature1.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    feature1.attributes = @{@"id": @"squircle"};
//    let feature1 = MGLPointFeature()
//    feature1.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
//    feature1.attributes = ["id": "squircle"]
    MGLPointFeature *feature2 = [MGLPointFeature alloc];
    feature2.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    feature2.attributes = @{@"id": @"oval"};
//    let feature2 = MGLPointFeature()
//    feature2.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
//    feature2.attributes = ["id": "oval"]
    MGLPointFeature *feature3 = [MGLPointFeature alloc];
    feature3.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768);
    feature3.attributes = @{@"id": @"star"};
//    let feature3 = MGLPointFeature()
//    feature3.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
//    feature3.attributes = ["id": "star"]
//
    MGLShapeCollectionFeature *shapeCollection = [MGLShapeCollectionFeature shapeCollectionWithShapes:@[feature1, feature2, feature3]];
    //    let shapeCollection = MGLShapeCollectionFeature(shapes: [feature1, feature2, feature3])
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"symbol-layer-z-order-example" shape:shapeCollection options:nil];
//    let source = MGLShapeSource(identifier: "symbol-layer-z-order-example", shape: shapeCollection, options: nil)
    [style addSource:source];
//    style.addSource(source)
    MGLSymbolStyleLayer *layer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"points-style" source:source];
//    let layer = MGLSymbolStyleLayer(identifier: "points-style", source: source)
    layer.sourceLayerIdentifier = @"symbol-layer-z-order-example";
//    layer.sourceLayerIdentifier = "symbol-layer-z-order-example"
//
//    // Create a stops dictionary with keys that are possible values for 'id', paired with icon images that will represent those features.
    NSDictionary *icons = @{@"squircle": @"squircle", @"oval": @"oval", @"star": @"star"};
//    let icons = ["squircle": "squircle", "oval": "oval", "star": "star"]
//    // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
    layer.iconImageName = [NSExpression expressionWithFormat:@"FUNCTION(%@, 'valueForKeyPath:', id)", icons];
    //    layer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', id)", icons)

    layer.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
//    layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
    layer.symbolZOrder = [NSExpression expressionForConstantValue:@"source"];
//    layer.symbolZOrder = NSExpression(forConstantValue: "source")
    [style addLayer:layer];
//    style.addLayer(layer)
//
//    self.symbolLayer = layer

    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"viewport-y", @"source"]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.tintColor = [UIColor colorWithRed:0.976 green:0.843 blue:0.831 alpha:1];
    styleToggle.backgroundColor = [UIColor colorWithRed:0.973 green:0.329 blue:0.294 alpha:1];
    styleToggle.layer.cornerRadius = 4;
    styleToggle.clipsToBounds = YES;
    styleToggle.selectedSegmentIndex = 1;
    [self.view insertSubview:styleToggle aboveSubview:self.mapView];
    [styleToggle addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventValueChanged];
//    // Create a UISegmentedControl to toggle between map styles
//    let styleToggle = UISegmentedControl(items: ["viewport-y", "source"])
//    styleToggle.translatesAutoresizingMaskIntoConstraints = false
//    styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
//    styleToggle.backgroundColor = UIColor(red: 0.973, green: 0.329, blue: 0.294, alpha: 1)
//    styleToggle.layer.cornerRadius = 4
//    styleToggle.clipsToBounds = true
//    styleToggle.selectedSegmentIndex = 1
//    view.insertSubview(styleToggle, aboveSubview: mapView)
//    styleToggle.addTarget(self, action: #selector(toggleLayer(sender:)), for: .valueChanged)
//
    
    // Configure autolayout constraints for the UISegmentedControl to align
    // at the bottom of the map view and above the Mapbox logo and attribution
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.logoView attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
    
    [self.view addConstraints:constraints];
//    // Configure autolayout constraints for the UISegmentedControl to align
//    // at the bottom of the map view and above the Mapbox logo and attribution
//    NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mapView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
//    NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
}

// Change the map style based on the selected index of the UISegmentedControl
- (void)changeStyle:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            self.mapView.styleURL = [MGLStyle satelliteStyleURL];
            break;
        case 1:
            self.mapView.styleURL = [MGLStyle streetsStyleURL];
            break;
        case 2:
            self.mapView.styleURL = [MGLStyle lightStyleURL];
            break;
    }
}
// Change the map style based on the selected index of the UISegmentedControl
//@objc func toggleLayer(sender: UISegmentedControl) {
//    switch sender.selectedSegmentIndex {
//    case 0:
//        useSource()
//    case 1:
//        useViewportY()
//    default:
//        useSource()
//    }
//}
//
- (void)useSource:(UISegmentedControl *)sender {
}
//func useSource() {
//    self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "source")
//}
//
- (void)useViewportY:(UISegmentedControl *)sender {
}
//func useViewportY() {
//    self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "viewport-y")
//}

@end
