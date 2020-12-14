#import "ManageOfflineRegionsExample.h"
@import Mapbox;

NSString *const MBXExampleManageOfflineRegions = @"ManageOfflineRegionsExample";


@interface ManageOfflineRegionsExample () <MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) MGLMapView *mapView;
@property (nonatomic) UIButton *downloadButton;
@property (nonatomic) UITableView *tableView;
@end

@implementation ManageOfflineRegionsExample

- (MGLMapView *)configureMapView {

     MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:CGRectZero];

    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    mapView.tintColor = UIColor.grayColor;
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return mapView;
}

- (UIButton *)configureDownloadButton
{
    UIButton *downloadButton = [[UIButton alloc] initWithFrame: CGRectZero];
    downloadButton.backgroundColor = UIColor.systemBlueColor;
    [downloadButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [downloadButton setTitle:@"Download Region" forState: UIControlStateNormal];
    [downloadButton addTarget:self action: @selector(startOfflinePackDownload:) forControlEvents:UIControlEventTouchUpInside];
    downloadButton.layer.cornerRadius = self.view.bounds.size.width / 30;
    downloadButton.translatesAutoresizingMaskIntoConstraints = NO;

    return downloadButton;
}


- (UITableView *)configureTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:@"cell"];
    return tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloadButton = [self configureDownloadButton];
    self.mapView = [self configureMapView];
    self.tableView = [self configureTableView];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    [self.mapView addSubview:self.downloadButton];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(22.27933, 114.16281)
                            zoomLevel:13
                             animated:NO];
    
    // Set up constraints for map view, table view, and download button.
    [self installConstraints];
    
}

-(void)setupOfflinePackHandler {
    // Setup offline pack notification handlers.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlinePackProgressDidChange:) name:MGLOfflinePackProgressChangedNotification object:nil];
}

-(void)installConstraints {

    NSArray *constraints = @[
        [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.mapView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.75],
        [self.tableView.topAnchor constraintEqualToAnchor:self.mapView.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.4],
        [self.downloadButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [self.downloadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:5],
        [self.downloadButton.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.45],
        [self.downloadButton.heightAnchor constraintEqualToAnchor:self.downloadButton.widthAnchor multiplier:0.2]
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

/*
  For the purposes of this example, remove any offline packs
  that exist before the example is re-loaded.
*/
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    // When leaving this view controller, suspend offline downloads.
    [[MGLOfflineStorage sharedOfflineStorage]
     resetDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            // Handle the error here if packs can't be removed.
            NSLog(@"Error: %@", error.localizedFailureReason);
        } else {
            // Start downloading.
            [[MGLOfflineStorage sharedOfflineStorage] reloadPacks];
        }
    }];
};

- (void)startOfflinePackDownload: (UIButton *)sender {
    // Setup offline pack notification handlers.
    [self setupOfflinePackHandler];

    /**
     Create a region that includes the current map camera, to be captured
     in an offline map. Note: Because tile count grows exponentially as zoom level
     increases, you should be conservative with your `toZoomLevel` setting.
     */
    MGLTilePyramidOfflineRegion *region = [[MGLTilePyramidOfflineRegion alloc] initWithStyleURL:self.mapView.styleURL
                bounds:self.mapView.visibleCoordinateBounds
        fromZoomLevel:self.mapView.zoomLevel
            toZoomLevel: self.mapView.zoomLevel + 2];
    
    // Store some data for identification purposes alongside the downloaded resources.
    NSDictionary *userInfo = @{ @"name": @"My Offline Pack" };
    NSData *context = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    
    // Create and register an offline pack with the shared offline storage object.
    [[MGLOfflineStorage sharedOfflineStorage] addPackForRegion:region withContext:context completionHandler:^(MGLOfflinePack *pack, NSError *error) {
        if (error != nil) {
            // Handle the error if the offline pack couldn’t be created.
            NSLog(@"Error: %@", error.localizedFailureReason);
        } else {
            // Begin downloading the map for offline use.
            [pack resume];
        }
    }];
}

#pragma mark - MGLOfflinePack notification handlers

- (void)offlinePackProgressDidChange:(NSNotification *)notification {
    /**
     Get the offline pack this notification is referring to,
     along with its associated metadata.
     */
    MGLOfflinePack *pack = notification.object;
    
    // Get the associated user info for the pack; in this case, `name = My Offline Pack`
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:pack.context];
    
    MGLOfflinePackProgress progress = pack.progress;
    uint64_t completedResources = progress.countOfResourcesCompleted;
    uint64_t expectedResources = progress.countOfResourcesExpected;
    
    // Calculate current progress percentage.
    float progressPercentage = (float)completedResources / expectedResources;
    
    // At this point, the offline pack has finished downloading.

    if (pack.state == MGLOfflinePackStateComplete) {
        NSString *byteCount = [NSByteCountFormatter
                               stringFromByteCount:progress.countOfBytesCompleted countStyle:NSByteCountFormatterCountStyleMemory];
        NSLog(@"Offline pack “%@” completed: %@, %llu resources",
              userInfo[@"name"], byteCount, completedResources);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MGLOfflinePackProgressChangedNotification object:nil];
        
    } else {
        // Otherwise, print download/verification progress.
        NSLog(@"Offline pack “%@” has %llu of %llu resources — %.2f%%.",
              userInfo[@"name"], completedResources,
              expectedResources, progressPercentage * 100);
    }

    // Reload the table to update the progress percentage for each offline pack.
    [self.tableView reloadData];

}

#pragma mark - UITableView configuration

// Create the table view which will display the downloaded regions.
- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (MGLOfflineStorage.sharedOfflineStorage.packs.count != 0) {
        return MGLOfflineStorage.sharedOfflineStorage.packs.count;
    } else {
        return 0;
    }

}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = UIColor.systemBlueColor;
    label.textColor = UIColor.whiteColor;
    label.font = [UIFont preferredFontForTextStyle: UIFontTextStyleHeadline];
    label.textAlignment = NSTextAlignmentCenter;


    if (MGLOfflineStorage.sharedOfflineStorage.packs != nil) {
        label.text = @"Offline maps";
    } else {
        label.text = @"No offline maps";
    }

    return label;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                 reuseIdentifier:@"cell"];
    
    if (MGLOfflineStorage.sharedOfflineStorage.packs.count != 0 )  {
        MGLOfflinePack * pack = MGLOfflineStorage.sharedOfflineStorage.packs[indexPath.row];
        NSInteger number = indexPath.row + 1;
        NSInteger countOfBytesCompleted = MGLOfflineStorage.sharedOfflineStorage.packs[indexPath.row].progress.countOfBytesCompleted;
        NSString *formattedCountOfBytedCompleted = [NSByteCountFormatter stringFromByteCount:countOfBytesCompleted countStyle:NSByteCountFormatterCountStyleMemory];
        UInt64 countOfResourcesCompleted = pack.progress.countOfResourcesCompleted;
        UInt64 countOfResourcesExpected = pack.progress.countOfResourcesExpected;
        
        float percentCompleted = ((countOfResourcesCompleted)/(countOfResourcesExpected) * 100);

        cell.textLabel.text = [NSString stringWithFormat:@"Region %ld: size: %@", number, formattedCountOfBytedCompleted];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"Percent completion: %.1f%%", percentCompleted];

    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGLTilePyramidOfflineRegion *selectedRegion = MGLOfflineStorage.sharedOfflineStorage.packs[indexPath.row].region;

    if ([selectedRegion isKindOfClass:[MGLTilePyramidOfflineRegion class]]) {
        [self.mapView setVisibleCoordinateBounds:selectedRegion.bounds animated:YES];
    }

}



@end
