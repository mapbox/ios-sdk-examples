#import "ChangeWorldviewBoundaries.h"

@import Mapbox;

NSString *const MBXExampleChangeWorldviewBoundaries = @"ChangeWorldviewBoundariesExample";

@interface ChangeWorldviewBoundariesExample ()

@property (nonatomic) MGLMapView *mapView;
@property MGLLineStyleLayer *layer;


@end

@implementation ChangeWorldviewBoundariesExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's initial style, center coordinate, and zoom level
    self.mapView.styleURL = [MGLStyle lightStyleURL];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(25.251, 95.69)
                            zoomLevel:3
                             animated:NO];
    [self.view addSubview:self.mapView];
    
    // Create a UISegmentedControl to toggle between map styles
    UISegmentedControl *styleToggle =[[UISegmentedControl alloc] initWithItems:@[@"  US  ", @"  CN  ", @"  IN  ", @"  All  "]];
    styleToggle.translatesAutoresizingMaskIntoConstraints = NO;
    styleToggle.tintColor = [UIColor colorWithRed:0.976f green:0.843f blue:0.831f alpha:1];
    styleToggle.backgroundColor = [UIColor colorWithRed:0.721f green:0.804f blue:0.831f alpha:1];
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
    
    // Change the map style based on the selected index of the UISegmentedControl
    - (void)changeStyle:(UISegmentedControl *)sender {
        
        MGLStyle *style = self.mapView.style;
        
        MGLVectorTileSource *source = [[MGLVectorTileSource alloc] initWithIdentifier:@"admin-bounds" configurationURL: [NSURL URLWithString:@"mapbox://mapbox.mapbox-streets-v8"]];
        
        if ([_layer.identifier  isEqual: @"admin"]) {
            printf("source already exists");
            [style removeLayer:_layer];
         
        } else {
            _layer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"admin" source:source];
            [style addSource:source];
        }
        _layer.sourceLayerIdentifier = @"admin";
        _layer.lineColor = [NSExpression expressionForConstantValue: UIColor.lightGrayColor];
        
        switch(sender.selectedSegmentIndex){
            case 0:
                printf("US");
                _layer.predicate = [ NSPredicate predicateWithFormat: @"CAST(worldview, 'NSString') == 'US'"];
                [style addLayer:_layer];
                break;
            case 1:
                printf("CN");
                 _layer.predicate = [ NSPredicate predicateWithFormat: @"CAST(worldview, 'NSString') == 'CN'"];
                [style addLayer:_layer];
                break;
            case 2:
                printf("IN");
                 _layer.predicate = [ NSPredicate predicateWithFormat: @"CAST(worldview, 'NSString') == 'IN'"];
                [style addLayer:_layer];
                break;
            case 3:
                printf("All");
                _layer.predicate = [ NSPredicate predicateWithFormat: @"CAST(worldview, 'NSString') == 'all'"];
                [style addLayer:_layer];
                break;
            default:
                [style addLayer:_layer];
                break;
        }
    }

@end
