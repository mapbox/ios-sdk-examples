
#import "MapSnapshotterExample.h"
@import Mapbox;

@interface MapSnapshotterExample ()

@property MGLMapView *mapView;
@property UIButton *button;

@end

NSString *const MBXExampleMapSnapshotter = @"MapSnapshotterExample";
@implementation MapSnapshotterExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle satelliteStreetsStyleURL]];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Center map on the Giza Pyramid Complex in Egypt.
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(29.9773, 31.1325);
    [_mapView setCenterCoordinate:center zoomLevel:14 animated:NO];
    [self.view addSubview:_mapView];
    
    // Create a button to take a map snapshot.
    _button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 15, self.view.bounds.size.height - 80, 30, 30)];
    _button.layer.cornerRadius = 15;
    [_button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(createSnapshot) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:_button];
}

- (void)createSnapshot {
    // Create a UIImageView that will store the map snapshot.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Use the map's style, camera, size, and zoom level to set the snapshot's options.
    MGLMapSnapshotOptions *options = [[MGLMapSnapshotOptions alloc] initWithStyleURL:_mapView.styleURL camera:_mapView.camera size:self.view.bounds.size];
    options.zoomLevel = _mapView.zoomLevel;
    
    // Create the map snapshot.
    MGLMapSnapshotter *snapshotter = [[MGLMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(MGLMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to create a map snapshot.");
        } else if (snapshot != nil) {
            imageView.image = snapshot.image;
            [self.view addSubview:imageView];
        }
    }];
}
@end
