#import "MGLMatchExample.h"
@import Mapbox;

NSString *const MBXExampleMGLMatch = @"MGLMatchExample";

@interface MGLMatchExample () <MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;
//@property (nonatomic) MGLSymbolStyleLayer *symbolLayer;
//@property (nonatomic) MGLStyle *style;


@end


@implementation MGLMatchExample
 
- (void)viewDidLoad {
[super viewDidLoad];
    
 self.mapView = [[MGLMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
 self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/zizim/ck12h05if04ha1co4qr1ra9l2"];
 [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(36.851, -119.448)
 zoomLevel:5
 animated:NO];
    _mapView.delegate = self;
 [self.view addSubview:self.mapView];

}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Add our GroJSON source to the map.
    NSURL *URL = [NSURL URLWithString:@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"];
        MGLSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"earthquakes" URL:URL options: nil];
    [self.mapView.style addSource:source];
    
    //set default values for color, opacity and radius
    UIColor *const defaultColor = UIColor.blueColor;
    NSExpression *const defaultRadius = [NSExpression expressionForConstantValue: @3];
    NSExpression *const defaultOpacity = [NSExpression expressionForConstantValue: @0.5];
    MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"earthquakes" source:source];
    // Style the circle layer color, opacity and radius based on type.
    layer.circleColor = [NSExpression expressionWithFormat: @"MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)", UIColor.magentaColor, UIColor.systemPinkColor, UIColor.systemPurpleColor, defaultColor];
    layer.circleOpacity = [NSExpression expressionWithFormat: @"MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)", [NSExpression expressionForConstantValue: @0.3], [NSExpression expressionForConstantValue: @0.3], [NSExpression expressionForConstantValue: @0.2], defaultOpacity];
    layer.circleRadius = [NSExpression expressionWithFormat:@"MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)",
    [NSExpression expressionForConstantValue: @3], [NSExpression expressionForConstantValue: @6], [NSExpression expressionForConstantValue: @9], defaultRadius];
    layer.circleStrokeColor = [NSExpression expressionForConstantValue: UIColor.darkGrayColor];
    layer.circleStrokeWidth = [NSExpression expressionForConstantValue: @1];
    [self.mapView.style addLayer:layer];
}

@end
