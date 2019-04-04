#import "MissingIconsExample.h"
@import Mapbox;

NSString *const MBXExampleMissingIcons = @"MissingIconsExample";

@interface MissingIconsExample ()<MGLMapViewDelegate>

@property (strong, nonatomic) MGLMapView *mapView;

@end

@implementation MissingIconsExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: This is a test case, it should be changed to fulfill an ios example spec.
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:[MGLStyle streetsStyleURL]];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(0, 0) zoomLevel:1 animated:NO];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    // Create a button to load the faulty style.
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = 15;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"Load faulty style" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(loadFaultyStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    if (@available(iOS 11.0, *)) {
        [NSLayoutConstraint activateConstraints:@[[button.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
                                                  [button.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor constant:20]
                                                  ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[[button.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:80],
                                                  [button.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20]
                                                  ]];
    }
 
}

- (void)loadFaultyStyle:(id) sender {
    NSURL *customStyleJSON = [[NSBundle mainBundle] URLForResource:@"missing_icon" withExtension:@"json"];
    [self.mapView setStyleURL:customStyleJSON];
}

- (UIImage *)mapView:(MGLMapView *)mapView didFailToLoadImage:(NSString *)imageName {
    if (![imageName isEqualToString:@"skip-this-missing-icon"]) {
        UIImage *backupImage = [UIImage imageNamed:@"mapbox"];
        return backupImage;
    }
    return nil;
}

@end
