#import "DrawingAGeoJSONLineExample.h"
@import Mapbox;

NSString *const MBXExampleDrawingAGeoJSONLine = @"DrawingAGeoJSONLineExample";

@interface DrawingAGeoJSONLineExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

@implementation DrawingAGeoJSONLineExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's center coordinate
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736)
                            zoomLevel:11
                             animated:NO];
    
    [self.view addSubview:self.mapView];
    
    // Set the delegate property of our map view to self after instantiating it.
    self.mapView.delegate = self;

    [self drawPolyline];
}

- (void)drawPolyline {
    // Perform GeoJSON parsing on a background thread
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^(void)
    {
        // Get the path for example.geojson in the app's bundle
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"geojson"];
       
        // Load and serialize the GeoJSON into a dictionary filled with properly-typed objects
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath] options:0 error:nil];
        
        // Load the `features` dictionary for iteration
        for (NSDictionary *feature in jsonDict[@"features"])
        {
            // Our GeoJSON only has one feature: a line string
            if ([feature[@"geometry"][@"type"] isEqualToString:@"LineString"])
            {
                // Get the raw array of coordinates for our line
                NSArray *rawCoordinates = feature[@"geometry"][@"coordinates"];
                NSUInteger coordinatesCount = rawCoordinates.count;
                
                // Create a coordinates array, sized to fit all of the coordinates in the line.
                // This array will hold the properly formatted coordinates for our MGLPolyline.
                CLLocationCoordinate2D coordinates[coordinatesCount];
                
                // Iterate over `rawCoordinates` once for each coordinate on the line
                for (NSUInteger index = 0; index < coordinatesCount; index++)
                {
                    // Get the individual coordinate for this index
                    NSArray *point = [rawCoordinates objectAtIndex:index];
                    
                    // GeoJSON is "longitude, latitude" order, but we need the opposite
                    CLLocationDegrees lat = [[point objectAtIndex:1] doubleValue];
                    CLLocationDegrees lng = [[point objectAtIndex:0] doubleValue];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
                    
                    // Add this formatted coordinate to the final coordinates array at the same index
                    coordinates[index] = coordinate;
                }
                
                // Create our polyline with the formatted coordinates array
                MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates count:coordinatesCount];
                
                // Optionally set the title of the polyline, which can be used for:
                //  - Callout view
                //  - Object identification
                // In this case, set it to the name included in the GeoJSON
                polyline.title = feature[@"properties"][@"name"]; // "Crema to Council Crest"
                
                // Add the polyline to the map, back on the main thread
                // Use weak reference to self to prevent retain cycle
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    [weakSelf.mapView addAnnotation:polyline];
                });
            }
        }
        
    });
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    // Set the alpha for all shape annotations to 1 (full opacity)
    return 1.0f;
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    // Set the line width for polyline annotations
    return 2.0f;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    // Set the stroke color for shape annotations
    // ... but give our polyline a unique color by checking for its `title` property
    if ([annotation.title isEqualToString:@"Crema to Council Crest"]) {
        // Mapbox cyan
        return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
    } else {
        return [UIColor redColor];
    }
}

@end
