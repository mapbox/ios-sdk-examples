#import "BlockingGesturesDelegateExample.h"
@import Mapbox;

NSString *const MBXExampleBlockingGesturesDelegate = @"BlockingGesturesDelegateExample";

@interface BlockingGesturesDelegateExample () <MGLMapViewDelegate>
@property (nonatomic) MGLCoordinateBounds colorado;
@end

@implementation BlockingGesturesDelegateExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.delegate = self;
    
    mapView.styleURL = [MGLStyle outdoorsStyleURLWithVersion:9];
    
    // Denver, Colorado
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.748947, -104.995882);
    
    // Starting point.
    [mapView setCenterCoordinate:center zoomLevel:10 direction:0 animated:NO];
    
    // Colorado's bounds
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(40.989329, -102.062592);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(36.986207, -109.049896);
    self.colorado = MGLCoordinateBoundsMake(sw, ne);
    
    [self.view addSubview:mapView];
}

- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera
{
    // Get current coordinates
    MGLCoordinateBounds visibleCoordinateBounds = mapView.visibleCoordinateBounds;
    CLLocationCoordinate2D newCameraCenter = newCamera.centerCoordinate;
    CLLocationCoordinate2D oldCameraCenter = oldCamera.centerCoordinate;
    
    // Get the offset from old camera center to current visible map bounds
    CGFloat neLatitudeOffset = visibleCoordinateBounds.ne.latitude - oldCameraCenter.latitude;
    CGFloat neLongitudeOffset = visibleCoordinateBounds.ne.longitude - oldCameraCenter.longitude;
    CGFloat swLatitudeOffset = visibleCoordinateBounds.sw.latitude - oldCameraCenter.latitude;
    CGFloat swLongitudeOffset = visibleCoordinateBounds.sw.longitude - oldCameraCenter.longitude;
    
    // Update the boundaries with new camera center + boundary offset
    CLLocationCoordinate2D newNE = CLLocationCoordinate2DMake(neLatitudeOffset + newCameraCenter.latitude, neLongitudeOffset + newCameraCenter.longitude);
    
    CLLocationCoordinate2D newSW = CLLocationCoordinate2DMake(swLatitudeOffset + newCameraCenter.latitude, swLongitudeOffset + newCameraCenter.longitude);
    MGLCoordinateBounds newBounds = MGLCoordinateBoundsMake(newSW, newNE);
    
    // Test if the new camera center point and boundaries are inside colorado
    BOOL inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado);
    BOOL intersects = MGLCoordinateInCoordinateBounds(newBounds.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newBounds.sw, self.colorado);
    
    return inside && intersects;

}

@end
