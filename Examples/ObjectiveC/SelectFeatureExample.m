#import "SelectFeatureExample.h"
@import Mapbox;

NSString *const MBXExampleSelectFeature = @"SelectFeatureExample";

@interface SelectFeatureExample () <MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) MGLShapeSource *selectedFeaturesSource;
@end

@implementation SelectFeatureExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Set the map's style to Mapbox Streets Style version 10. The style's layers will be queried later.
    self.mapView.styleURL = [MGLStyle streetsStyleURLWithVersion:10];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(45.5076, -122.6736) zoomLevel:11 animated:NO];

    // Add our own gesture recognizer to handle taps on our custom map features. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMap:)];
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [singleTap requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:singleTap];

    self.mapView.delegate = self;

    [self.view addSubview:self.mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    // Create a placeholder MGLShapeSource that will hold copies of any features we’ve selected.
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"selected-features" features:@[] options:nil];
    [style addSource:source];

    // Keep a reference to the source so we can update it when the map is tapped.
    self.selectedFeaturesSource = source;

    // Color any selected features red on the map.
    MGLFillStyleLayer *selectedFeaturesLayer = [[MGLFillStyleLayer alloc] initWithIdentifier:@"selected-features" source:source];
    selectedFeaturesLayer.fillColor = [NSExpression expressionForConstantValue:[UIColor redColor]];

    [style addLayer:selectedFeaturesLayer];
}

- (IBAction)didTapMap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // A tap’s center coordinate may not intersect a feature exactly, so let’s make a 44x44 rect that represents a touch and select all features that interesect.
        CGRect pointRect = { [recognizer locationInView:recognizer.view], CGSizeZero };
        CGRect touchRect = CGRectInset(pointRect, -22.0, -22.0);

        // Let’s only select parks near the rect. There’s a layer within the Mapbox Streets style with "id" = "park". You can see all of the layers used within the default mapbox styles by creating a new style using Mapbox Studio.
        NSSet *layerIdentifiers = [NSSet setWithObject:@"park"];

        // Query the current mapview for any features that intersect our rect.
        NSMutableArray *features = [NSMutableArray array];
        for (id f in [self.mapView visibleFeaturesInRect:touchRect inStyleLayersWithIdentifiers:layerIdentifiers]) {
            [features addObject:f];
        }

        MGLShapeCollectionFeature *shapes = [MGLShapeCollectionFeature shapeCollectionWithShapes:features];

        // Update our MGLShapeSource to match our selected features.
        self.selectedFeaturesSource.shape = shapes;
    }
}

@end
