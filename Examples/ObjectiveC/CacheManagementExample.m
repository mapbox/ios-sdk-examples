#import "CacheManagementExample.h"
@import Mapbox;

NSString *const MBXExampleCacheManagement = @"CacheManagementExample";

@interface CacheManagementExample () <MGLMapViewDelegate, UIActionSheetDelegate>

@property (nonatomic) MGLMapView *mapView;
@property (nonatomic) UIButton *alertButton;
@property (nonatomic) UIAlertController *alertController;
@end

@implementation CacheManagementExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger maximumCacheSize = 41943040;

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    [self addButton];
}

- (void)addOfflinePack {

}

#pragma mark: Cache management methods called by action sheet
- (void)invalidateAmbientCache {
    
}

- (void)invalidateOfflinePack {

}

- (void)clearAmbientCache {
    
}

- (void)resetDatabase {
    
}

- (NSUInteger)getCacheSize {
    return 0;
}

# pragma mark: Add UI components
- (void)addButton {
    self.alertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}
- (void)addMenu {

    if (!self.alertController) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"Cache Management Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *actions = @[@"Invalidate Ambient Cache", @"Invalidate Offline Pack", @"Clear Ambient Cache", @"Reset Database"];

        for (NSString *action in actions) {
            [self.alertController addAction:[UIAlertAction actionWithTitle:action style:UIAlertActionStyleDefault handler:nil]];
        }
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }

    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self invalidateAmbientCache];
            break;
        case 1:
            [self invalidateOfflinePack];
            break;
        case 2:
            [self clearAmbientCache];
            break;
        case 3:
            [self resetDatabase];
        default:
            break;
    }
}
@end
