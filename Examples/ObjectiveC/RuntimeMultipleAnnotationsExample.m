//
//  RuntimeMultipleAnnotationsExample.m
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#import "RuntimeMultipleAnnotationsExample.h"
@import Mapbox;

NSString *const MBXExampleRuntimeMultipleAnnotations = @"RuntimeMultipleAnnotationsExample";

@interface RuntimeMultipleAnnotationsExample ()<MGLMapViewDelegate>

@property (nonatomic) MGLMapView *mapView;

@end

@implementation RuntimeMultipleAnnotationsExample

- (void)viewDidLoad {
    [super viewDidLoad];

    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;

    [self.view addSubview:mapView];

    self.mapView = mapView;
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    [self loadAnnotations];
}

- (void)loadAnnotations {
    // Wikidata query for all lighthouses in the United States: https://query.wikidata.org/#%23added%20before%202016-10%0A%23defaultView%3AMap%0ASELECT%20DISTINCT%20%3Fitem%20%3FitemLabel%20%3Fcoor%20%3Fimage%0AWHERE%0A%7B%0A%09%3Fitem%20wdt%3AP31%20wd%3AQ39715%20.%20%0A%09%3Fitem%20wdt%3AP17%20wd%3AQ30%20.%0A%09%3Fitem%20wdt%3AP625%20%3Fcoor%20.%0A%09OPTIONAL%20%7B%20%3Fitem%20wdt%3AP18%20%3Fimage%20%7D%20%20%0A%09SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%20%7D%20%20%0A%7D%0AORDER%20BY%20%3FitemLabel
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

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
	if (!data) return;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	NSArray *items = json[@"results"][@"bindings"];
	if (!items) return;
	dispatch_async(dispatch_get_main_queue(), ^{
	    [self mapItems:items];
	});
    }] resume];
}

- (void)mapItems:(NSArray *)items {
    NSArray *features = [self parseJSONItems:items];

    MGLGeoJSONSource *source = [[MGLGeoJSONSource alloc] initWithIdentifier:@"lighthouses" features:features options:nil];

    UIColor *lighthouseColor = [UIColor colorWithRed:0.45 green:0.32 blue:0.23 alpha:1.0];

    MGLCircleStyleLayer *circles = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"lighthouse-circles" source:source];
    circles.circleColor = [MGLStyleValue valueWithRawValue:lighthouseColor];
    circles.circleOpacity = [MGLStyleValue valueWithStops:@{
	@2: [MGLStyleValue valueWithRawValue:@0.5],
	@7: [MGLStyleValue valueWithRawValue:@1.0],
    }];
    circles.circleRadius = [MGLStyleValue valueWithStops:@{
	@2: [MGLStyleValue valueWithRawValue:@2],
	@7: [MGLStyleValue valueWithRawValue:@3],
    }];

    MGLSymbolStyleLayer *symbols = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"lighthouse-symbols" source:source];
    symbols.iconImage = [MGLStyleValue valueWithRawValue:@"circle-15"];
    symbols.iconColor = [MGLStyleValue valueWithRawValue:lighthouseColor];
    symbols.iconOpacity = [MGLStyleValue valueWithStops:@{
	@5.9: [MGLStyleValue valueWithRawValue:@0],
	@6: [MGLStyleValue valueWithRawValue:@1],
    }];
    symbols.iconHaloColor = [MGLStyleValue valueWithRawValue:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    symbols.iconHaloWidth = [MGLStyleValue valueWithRawValue:@1];
    symbols.textColor = symbols.iconColor;
    symbols.textField = [MGLStyleValue valueWithRawValue:@"{name}"];
    symbols.textSize = [MGLStyleValue valueWithStops:@{
	@10: [MGLStyleValue valueWithRawValue:@10],
	@16: [MGLStyleValue valueWithRawValue:@16],
    }];
    symbols.textTranslate = [MGLStyleValue valueWithRawValue:[NSValue valueWithCGVector:CGVectorMake(10, 0)]];
    symbols.textOpacity = symbols.iconOpacity;
    symbols.textHaloColor = symbols.iconHaloColor;
    symbols.textHaloWidth = symbols.iconHaloWidth;
    symbols.textJustify = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLTextJustify:MGLTextJustifyLeft]];
    symbols.textAnchor = [MGLStyleValue valueWithRawValue:[NSValue valueWithMGLTextAnchor:MGLTextAnchorLeft]];

    [[self.mapView style] addSource:source];
    [[self.mapView style] addLayer:circles];
    [[self.mapView style] addLayer:symbols];
}

- (NSArray *)parseJSONItems:(NSArray *)items {
    NSMutableArray *features = @[].mutableCopy;
    for (NSDictionary *item in items) {
	NSString *title = item[@"itemLabel"][@"value"];
	NSString *point = item[@"coor"][@"value"];
	if (!item || !point) continue;

	NSString *parsedPoint = [[point stringByReplacingOccurrencesOfString:@"Point(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
	NSArray *pointComponents = [parsedPoint componentsSeparatedByString:@" "];

	MGLPointFeature *feature = [[MGLPointFeature alloc] init];
	feature.coordinate = CLLocationCoordinate2DMake([pointComponents[1] doubleValue], [pointComponents[0] doubleValue]);
	feature.attributes = @{
	    @"name": title,
	};
	[features addObject:feature];
    }
    return features;
}

@end
