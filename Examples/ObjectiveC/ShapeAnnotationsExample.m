#import "ShapeAnnotationsExample.h"
@import Mapbox;

NSString *const MBXExampleShapeAnnotations = @"ShapeAnnotationsExample";

@interface ShapeAnnotationsExample () <MGLMapViewDelegate>

@property MGLPointAnnotation *pointAnnotation;
@property MGLPolyline *lineAnnotation;
@property MGLPolygon *polygonAnnotation;

@end

@implementation ShapeAnnotationsExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.frame];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.520, -122.663) zoomLevel:13 animated:NO];
    // Allow this ViewController class to be the reciever of `MGLMapViewDelegate` events.
    mapView.delegate = self;
    [self.view addSubview:mapView];

    [self setupAnnotations];

    // Add all three shapes to the map.
    [mapView addAnnotations:@[self.pointAnnotation, self.lineAnnotation, self.polygonAnnotation]];
}

// Allows callouts to be displayed when the annotation is selected.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

// Assigns a fill color for the polygon annotation.
- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
    return [UIColor colorWithRed: 1.00 green: 0.96 blue: 0.00 alpha: 0.4];
}

// Assigns a stroke or "outline" color for non-point annotations.
-(UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return [UIColor colorWithRed: 0.00 green: 0.46 blue: 1.00 alpha: 1.0];
}

// Assigns a width for to the line annotation.
- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    return 8.0;
}

- (void)setupAnnotations {
    // Three shapes annotations are created below: a point, line, and a polygon.
    MGLPointAnnotation *pointAnnotation = [[MGLPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(45.531, -122.666);
    pointAnnotation.title = @"Event venue";

     // Since structs aren't supported in Objective-C arrays,
     // store coordinates in a compatible C++ array instead.
    CLLocationCoordinate2D lineCoordinates[] = {
        CLLocationCoordinate2DMake(45.526, -122.677),
        CLLocationCoordinate2DMake(45.523, -122.677),
        CLLocationCoordinate2DMake(45.523, -122.674),
        CLLocationCoordinate2DMake(45.522, -122.674),
        CLLocationCoordinate2DMake(45.518, -122.676),
        CLLocationCoordinate2DMake(45.517, -122.673),
        CLLocationCoordinate2DMake(45.513, -122.676)
    };

    NSUInteger lineCoordinateCount = sizeof(lineCoordinates) / sizeof(CLLocationCoordinate2D);
    MGLPolyline *lineAnnotation = [MGLPolyline polylineWithCoordinates:lineCoordinates count:lineCoordinateCount];
    lineAnnotation.title = @"Parade route";

    CLLocationCoordinate2D polygonCoordinates[] = {
        CLLocationCoordinate2DMake(45.512, -122.663),
        CLLocationCoordinate2DMake(45.512, -122.654),
        CLLocationCoordinate2DMake(45.522, -122.654),
        CLLocationCoordinate2DMake(45.522, -122.663),
        CLLocationCoordinate2DMake(45.512, -122.663)
    };

    NSUInteger polygonCoordinateCount = sizeof(polygonCoordinates) / sizeof(CLLocationCoordinate2D);
    MGLPolygon *polygonAnnotation = [MGLPolygon polygonWithCoordinates:polygonCoordinates count:polygonCoordinateCount];
    polygonAnnotation.title = @"Limited parking";

    self.pointAnnotation = pointAnnotation;
    self.lineAnnotation = lineAnnotation;
    self.polygonAnnotation = polygonAnnotation;
}

@end
