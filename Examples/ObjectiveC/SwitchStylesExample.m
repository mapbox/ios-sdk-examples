#import "SwitchStylesExample.h"
@import Mapbox;

NSString *const MBXExampleSwitchStyles = @"SwitchStylesExample";

@interface SwitchStylesExample ()

@property (nonatomic) MGLMapView *mapView;

@end

@implementation SwitchStylesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's initial style, center coordinate, and zoom level
    self.mapView.styleURL = [MGLStyle streetsStyleURL];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.10, -81.76)];
    [self.mapView setZoomLevel:5.4];
    [self.view addSubview:self.mapView];
    
    // Create a UISegmentedControl to toggle between map styles
    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"Dark", @"Streets", @"Light"]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.selectedSegmentIndex = 1;
    [self.view insertSubview:styleToggle aboveSubview:self.mapView];
    [styleToggle addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventValueChanged];
    
    // Configure autolayout constraints for the UISegmentedControl to align
    // at the bottom of the map view and above the Mapbox logo and attribution
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[styleToggle]-40-|" options:0 metrics:0 views:@{@"styleToggle":styleToggle}]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:styleToggle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView.logoView attribute:NSLayoutAttributeTop multiplier:1 constant:-20]];
    [self.view addConstraints:constraints];
}

// Change the map style based on the selected index of the UISegmentedControl
- (void)changeStyle:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex){
        case 0:
            self.mapView.styleURL = [MGLStyle darkStyleURL];
            break;
        case 1:
            self.mapView.styleURL = [MGLStyle streetsStyleURL];
            break;
        case 2:
            self.mapView.styleURL = [MGLStyle lightStyleURL];
            break;
    }
}

@end
