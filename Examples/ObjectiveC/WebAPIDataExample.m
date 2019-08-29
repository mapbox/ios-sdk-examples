#import "WebAPIDataExample.h"
@import Mapbox;

NSString *const MBXExampleWebAPIData = @"WebAPIDataExample";

@interface WebAPIDataExample ()<MGLMapViewDelegate>
@property (nonatomic) MGLMapView *mapView;
@end

@implementation WebAPIDataExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.090240, -95.712891) zoomLevel:2 animated:NO];

    self.mapView.delegate = self;

    // Add our own gesture recognizer to handle taps on our custom map features. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    for (UIGestureRecognizer *recognizer in self.mapView.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [singleTap requireGestureRecognizerToFail:recognizer];
        }
    }
    [self.mapView addGestureRecognizer:singleTap];

    [self.view addSubview:self.mapView];
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self fetchPoints:^(NSArray *features) {
        [self addItemsToMap:features];
    }];
}

- (void)addItemsToMap:(NSArray *)features {
    // You can add custom UIImages to the map style.
    // These can be referenced by an MGLSymbolStyleLayer’s iconImage property.
    [self.mapView.style setImage:[UIImage imageNamed:@"lighthouse"] forName:@"lighthouse"];

    // Add the features to the map as a MGLShapeSource.
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"lighthouses" features:features options:nil];
    [self.mapView.style addSource:source];

    UIColor *lighthouseColor = [UIColor colorWithRed:0.08f green:0.44f blue:0.96f alpha:1];

    // Use MGLCircleStyleLayer to represent the points with simple circles.
    // In this case, we can use style functions to gradually change properties between zoom level 2 and 7: the circle opacity from 50% to 100% and the circle radius from 2pt to 3pt.
    MGLCircleStyleLayer *circles = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"lighthouse-circles" source:source];
    circles.circleColor = [NSExpression expressionForConstantValue:lighthouseColor];
    
    // The circles should increase in opacity from 0.5 to 1 based on zoom level.
    circles.circleOpacity = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                             @{@2: @0.5, @7: @1.0 }];
    circles.circleRadius = circles.circleRadius = [NSExpression expressionWithFormat:@"mgl_step:from:stops:($zoomLevel, 1, %@)",
                                                   @{@2: @2, @7: @3}];

    // Use MGLSymbolStyleLayer for more complex styling of points including custom icons and text rendering.
    MGLSymbolStyleLayer *symbols = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"lighthouse-symbols" source:source];
    symbols.iconImageName = [NSExpression expressionForConstantValue:@"lighthouse"];
    symbols.iconScale = [NSExpression expressionForConstantValue:@0.5];
    symbols.iconOpacity = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                           @{@5.9: @0, @6: @1}];
    symbols.iconHaloColor = [NSExpression expressionForConstantValue:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    symbols.iconHaloWidth = [NSExpression expressionForConstantValue:@1];
    // "name" references the "name" key in an MGLPointFeature’s attributes dictionary.
    symbols.text = [NSExpression expressionForKeyPath:@"name"];
    symbols.textColor = symbols.iconColor;
    symbols.textFontSize = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                            @{@10: @10, @16: @16}];
    symbols.textTranslation = [NSExpression expressionForConstantValue:[NSValue valueWithCGVector:CGVectorMake(10, 0)]];
    symbols.textOpacity = symbols.iconOpacity;
    symbols.textHaloColor = symbols.iconHaloColor;
    symbols.textHaloWidth = symbols.iconHaloWidth;
    symbols.textJustification = [NSExpression expressionForConstantValue:[NSValue valueWithMGLTextJustification:MGLTextJustificationLeft]];
    symbols.textAnchor = [NSExpression expressionForConstantValue:[NSValue valueWithMGLTextAnchor:MGLTextAnchorLeft]];

    [self.mapView.style addLayer:circles];
    [self.mapView.style addLayer:symbols];
}

#pragma mark - Feature interaction

- (IBAction)handleMapTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        // Limit feature selection to just the following layer identifiers.
        NSArray *layerIdentifiers = @[@"lighthouse-symbols", @"lighthouse-circles"];

        CGPoint point = [sender locationInView:sender.view];

        // Try matching the exact point first
        for (id f in [self.mapView visibleFeaturesAtPoint:point inStyleLayersWithIdentifiers:[NSSet setWithArray:layerIdentifiers]]) {
            if ([f isKindOfClass:[MGLPointFeature class]]) {
                [self showCallout:f];
                return;
            }
        }

        // Otherwise, get first features within a rect the size of a touch (44x44).
        CGRect pointRect = {point, CGSizeZero};
        CGRect touchRect = CGRectInset(pointRect, -22.0, -22.0);
        for (id f in [self.mapView visibleFeaturesInRect:touchRect inStyleLayersWithIdentifiers:[NSSet setWithArray:layerIdentifiers]]) {
            if ([f isKindOfClass:[MGLPointFeature class]]) {
                [self showCallout:f];
                return;
            }
        }

        // If no features were found, deselect the selected annotation, if any.
        [self.mapView deselectAnnotation:[[self.mapView selectedAnnotations] firstObject] animated:YES];
    }
}

- (void)showCallout:(MGLPointFeature *)feature {
    MGLPointFeature *point = [[MGLPointFeature alloc] init];
    point.title = feature.attributes[@"name"];
    point.coordinate = feature.coordinate;

    // Selecting an feature that doesn’t already exist on the map will add a new annotation view.
    // We’ll need to use the map’s delegate methods to add an empty annotation view and remove it when we’re done selecting it.
    [self.mapView selectAnnotation:point animated:YES completionHandler:nil];
}

#pragma mark - MGLMapViewDelegate

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

- (void)mapView:(MGLMapView *)mapView didDeselectAnnotation:(id <MGLAnnotation>)annotation {
    [mapView removeAnnotation:annotation];
}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    // Create an empty view annotation. Set a frame to offset the callout.
    return [[MGLAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
}

#pragma mark - Data fetching and parsing

- (void)fetchPoints:(void (^)(NSArray *))completion {
    // Wikidata query for all lighthouses in the United States: http://tinyurl.com/zrl2jc4
    NSString *query = @"SELECT DISTINCT ?item "
	"?itemLabel ?coor ?image "
	"WHERE "
	    "{ "
	    "?item wdt:P31 wd:Q39715 . "
	    "?item wdt:P17 wd:Q30 . "
	    "?item wdt:P625 ?coor . "
	    "OPTIONAL { ?item wdt:P18 ?image } . "
	    "SERVICE wikibase:label { bd:serviceParam wikibase:language \"en\" } "
	"} "
	"ORDER BY ?itemLabel";

    NSMutableCharacterSet *characterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [characterSet removeCharactersInString:@"?"];
    [characterSet removeCharactersInString:@"&"];
    [characterSet removeCharactersInString:@":"];

    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:characterSet];

    NSString *urlString = [NSString stringWithFormat:@"https://query.wikidata.org/sparql?query=%@&format=json", encodedQuery];

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data) return;

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *items = json[@"results"][@"bindings"];

        if (!items) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self parseJSONItems:items]);
        });
    }] resume];
}

- (NSArray *)parseJSONItems:(NSArray *)items {
    NSMutableArray *features = [NSMutableArray array];
    for (NSDictionary *item in items) {
        NSString *title = item[@"itemLabel"][@"value"];
        NSString *point = item[@"coor"][@"value"];
        if (!item || !point) continue;

        NSString *parsedPoint = [[point stringByReplacingOccurrencesOfString:@"Point(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *pointComponents = [parsedPoint componentsSeparatedByString:@" "];

        MGLPointFeature *feature = [[MGLPointFeature alloc] init];
        feature.coordinate = CLLocationCoordinate2DMake([pointComponents[1] doubleValue], [pointComponents[0] doubleValue]);
        feature.title = title;
        // A feature’s attributes can used by runtime styling for things like text labels.
        feature.attributes = @{
            @"name": title,
        };
        [features addObject:feature];
    }
    return features;
}

@end
