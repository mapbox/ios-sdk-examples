
#import "MapSnapshotterExample.h"
@import Mapbox;

@interface MapSnapshotterExample ()

@end

NSString *const MBXExampleMapSnapshotter = @"MapSnapshotterExample";
@implementation MapSnapshotterExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    // Center map on the Giza Pyramid Complex in Egypt.
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(29.9773, 31.1325);
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:center fromDistance:0 pitch:0 heading:0];
    
    
    MGLMapSnapshotOptions *options = [[MGLMapSnapshotOptions alloc] initWithStyleURL:[MGLStyle satelliteStreetsStyleURL] camera:camera size:self.view.bounds.size];
    options.zoomLevel = 14;
    
    MGLMapSnapshotter *snapshotter = [[MGLMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(MGLMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to create a map snapshot.");
        } else if (snapshot != nil) {
            imageView.image = snapshot.image;
        }
    }];
}

@end
