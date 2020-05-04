#import "StaticSnapshotExample.h"
@import Mapbox;

NSString *const MBXExampleStaticSnapshot = @"StaticSnapshotExample";

@interface StaticSnapshotExample ()

@property MGLMapView *mapView;
@property UIButton *button;
@property UIImageView *imageView;

@end

@implementation StaticSnapshotExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MGLMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2) styleURL:[MGLStyle satelliteStreetsStyleURL]];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Center map on the Giza Pyramid Complex in Egypt.
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(29.9773, 31.1325);
    [_mapView setCenterCoordinate:center zoomLevel:14 animated:NO];
    [self.view addSubview:_mapView];
    
    // Create a button to take a map snapshot.
    _button = [[UIButton alloc] initWithFrame:CGRectMake(_mapView.bounds.size.width / 2 - 15, _mapView.bounds.size.height - 40, 80, 30)];
    _button.layer.cornerRadius = 15;
    _button.backgroundColor = [UIColor colorWithRed:0.96f green:0.65f blue:0.14f alpha:1];
    [_button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(createSnapshot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    // Create a UIImageView that will store the map snapshot.
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_imageView];
}

- (void)createSnapshot {
    // Use the map's style, camera, size, and zoom level to set the snapshot's options.
    MGLMapSnapshotOptions *options = [[MGLMapSnapshotOptions alloc] initWithStyleURL:_mapView.styleURL camera:_mapView.camera size:_mapView.bounds.size];
    options.zoomLevel = _mapView.zoomLevel;
    
    // Add an activity indicator to show that the snapshot is loading.
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_imageView.center.x - 30, _imageView.center.y - 30, 60, 60)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    // Create the map snapshot.
    MGLMapSnapshotter *snapshotter = [[MGLMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(MGLMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to create a map snapshot.");
        } else if (snapshot != nil) {
            // Add the map snapshot's image to the image view.
            [indicator stopAnimating];
            self.imageView.image = snapshot.image;
        }
    }];
}
@end
