
#import "ClusteringWithImagesExample.h"
@import Mapbox;

NSString *const MBXExampleClusteringWithImages = @"ClusteringWithImagesExample";

@interface ClusteringWithImagesExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIImage *icon;

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
    
    self.icon = [UIImage imageNamed:@"circle"];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ports" ofType:@"geojson"]];
    
    // Retrieve data and set as style layer source
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"clusteredPorts" URL:url options:@{
                              MGLShapeSourceOptionClustered:@(YES),
                              MGLShapeSourceOptionClusterRadius: @(self.icon.size.width)
    }];
    [style addSource:source];
    
    MGLSymbolStyleLayer *numbersLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"clusteredPortsNumbers" source:source];
    numbersLayer.textColor = [NSExpression expressionForConstantValue:[UIColor whiteColor]];
    numbersLayer.textFontSize = [NSExpression expressionForConstantValue:@(self.icon.size.width / 2)];
    numbersLayer.iconAllowsOverlap = [NSExpression expressionForConstantValue:@(YES)];
    
    // Style clusters
    [style setImage:[UIImage imageNamed:@"circle"] forName:@"circle"];
    [style setImage:[UIImage imageNamed:@"rectangle"] forName:@"rectangle"];
    [style setImage:[UIImage imageNamed:@"cloud"] forName:@"cloud"];
    [style setImage:[UIImage imageNamed:@"oval"] forName:@"oval"];
    
    NSDictionary *stops = @{ @10: [NSExpression expressionForConstantValue:@"circle"],
                             @25: [NSExpression expressionForConstantValue:@"rectangle"],
                             @75: [NSExpression expressionForConstantValue:@"cloud"],
                             @150: [NSExpression expressionForConstantValue:@"oval"] };
    
    NSExpression *defaultCircle = [NSExpression expressionForConstantValue:@"circle"];
    numbersLayer.iconImageName = [NSExpression expressionWithFormat:@"mgl_step:from:stops:(point_count, %@, %@)", defaultCircle, stops];
    numbersLayer.text = [NSExpression expressionWithFormat:@"CAST(point_count, 'NSString')"];
    
    [style addLayer:numbersLayer];
}

@end
