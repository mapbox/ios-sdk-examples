
#import "ClusteringWithImagesExample.h"
@import Mapbox;

NSString *const MBXExampleClusteringWithImages = @"ClusteringWithImagesExample";

@interface ClusteringWithImagesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIImage *marker;

@end

@implementation ClusteringWithImagesExample


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the Map
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds
                                            styleURL:[MGLStyle lightStyleURL]];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Define an initial icon to help set source attributes
    self.icon = [UIImage imageNamed:@"squircle"];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ports" ofType:@"geojson"]];
    
    // Retrieve data and set as source. This associates the data with the map, but style layers are still required to make data visible.
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"clusteredPorts" URL:url options:@{
                              MGLShapeSourceOptionClustered:@(YES),
                              MGLShapeSourceOptionClusterRadius: @(self.icon.size.width)
    }];
    [style addSource:source];
    
    // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
    // This example requires two style layers to work properly: one for clustered points and one for unclustered points
    MGLSymbolStyleLayer *markerLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"ports" source:source];
    markerLayer.iconImageName = [NSExpression expressionForConstantValue:@"marker"];
    markerLayer.predicate = [NSPredicate predicateWithFormat:@"cluster != YES"];
    [style addLayer:markerLayer];
    [style setImage:[UIImage imageNamed:@"marker"] forName:@"marker"];
    
    // Create image cluster style layer
    MGLSymbolStyleLayer *clusterLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"clusteredPortsNumbers" source:source];
    clusterLayer.textColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    clusterLayer.textFontSize = [NSExpression expressionForConstantValue:@(self.icon.size.width / 2)];
    clusterLayer.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
    
    // Style image clusters
    [style setImage:[UIImage imageNamed:@"squircle"] forName:@"squircle"];
    [style setImage:[UIImage imageNamed:@"circle"] forName:@"circle"];
    [style setImage:[UIImage imageNamed:@"rectangle"] forName:@"rectangle"];
    [style setImage:[UIImage imageNamed:@"star"] forName:@"star"];
    [style setImage:[UIImage imageNamed:@"oval"] forName:@"oval"];
    
    NSDictionary *stops = @{ @10: [NSExpression expressionForConstantValue:@"circle"],
                             @25: [NSExpression expressionForConstantValue:@"rectangle"],
                             @75: [NSExpression expressionForConstantValue:@"star"],
                             @150: [NSExpression expressionForConstantValue:@"oval"] };

    // Use expressions to set each cluster's image based on defined stops and display the point count over the corresponding image
    NSExpression *defaultShape = [NSExpression expressionForConstantValue:@"squircle"];
    clusterLayer.iconImageName = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(point_count, %@, %@)", defaultShape, stops];
    clusterLayer.text = [NSExpression expressionWithFormat:@"CAST(point_count, 'NSString')"];
    
    [style addLayer:clusterLayer];
}

@end
