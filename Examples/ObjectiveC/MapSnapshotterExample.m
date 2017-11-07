
#import "MapSnapshotterExample.h"
@import Mapbox;

@interface MapSnapshotterExample () <MGLMapViewDelegate>

@end

NSString *const MBXExampleMapSnapshotter = @"MapSnapshotterExample";
@implementation MapSnapshotterExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Center map on the Giza Pyramid Complex in Egypt.
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(29.9773, 31.1325);
    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:center fromDistance:0 pitch:0 heading:0];
    
    
    MGLMapSnapshotOptions *options = [[MGLMapSnapshotOptions alloc] initWithStyleURL:[MGLStyle satelliteStreetsStyleURL] camera:camera size:self.view.bounds.size];
    options.zoomLevel = 14;
    
    MGLMapSnapshotter *snapshotter = [[MGLMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(UIImage * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to create a map snapshot.");
        } else if (snapshot != nil) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:snapshot];
            [self.view addSubview:imageView];
        }
    }];
    
}

@end
