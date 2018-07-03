#import "AnnotationViewExample.h"
@import Mapbox;

NSString *const MBXExampleAnnotationView = @"AnnotationViewExample";

// MGLAnnotationView subclass
@interface CustomAnnotationView : MGLAnnotationView
@end

@implementation CustomAnnotationView

- (void)layoutSubviews {
    [super layoutSubviews];

    // Use CALayer’s corner radius to turn this view into a circle.
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Increase the size of the annotation if it is selected, and restore annotation to its original size if it is not selected.
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [self.layer addAnimation:animation forKey:@"bounds.size"];
    if (selected) {
        [self.layer setAffineTransform:CGAffineTransformMakeScale(2, 2)];
    } else {
        [self.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
    }
}

@end


//
// Example view controller
@interface AnnotationViewExample () <MGLMapViewDelegate>
@end

@implementation AnnotationViewExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.styleURL = [MGLStyle darkStyleURL];
    mapView.tintColor = [UIColor lightGrayColor];
    mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 66);
    mapView.zoomLevel = 2;
    mapView.delegate = self;
    [self.view addSubview:mapView];

    // Specify coordinates for our annotations.
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(0, 33),
        CLLocationCoordinate2DMake(0, 66),
        CLLocationCoordinate2DMake(0, 99),
    };
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);

    // Fill an array with point annotations and add it to the map.
    NSMutableArray *pointAnnotations = [NSMutableArray arrayWithCapacity:numberOfCoordinates];
    for (NSUInteger i = 0; i < numberOfCoordinates; i++) {
        CLLocationCoordinate2D coordinate = coordinates[i];
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        point.coordinate = coordinate;
        point.title = [NSString stringWithFormat:@"%.f, %.f", coordinate.latitude, coordinate.longitude];
        [pointAnnotations addObject:point];
    }

    [mapView addAnnotations:pointAnnotations];
}

#pragma mark - MGLMapViewDelegate methods

// This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    // This example is only concerned with point annotations.
    if (![annotation isKindOfClass:[MGLPointAnnotation class]]) {
        return nil;
    }

    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%f", annotation.coordinate.longitude];

    // For better performance, always try to reuse existing annotations.
    CustomAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];

    // If there’s no reusable annotation view available, initialize a new one.
    if (!annotationView) {
        annotationView = [[CustomAnnotationView alloc] initWithReuseIdentifier:reuseIdentifier];
        annotationView.bounds = CGRectMake(0, 0, 40, 40);

        // Set the annotation view’s background color to a value determined by its longitude.
        CGFloat hue = (CGFloat)annotation.coordinate.longitude / 100;
        annotationView.backgroundColor = [UIColor colorWithHue:hue saturation:0.5 brightness:1 alpha:1];
    }

    return annotationView;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return YES;
}

// Adjust the positioning of the callout view once the annotation is selected.
- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
    [mapView layoutSubviews];
}

@end
