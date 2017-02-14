import Mapbox

@objc(BlockingGesturesDelegateExample_Swift)

class BlockingGesturesDelegateExample_Swift: UIViewController, MGLMapViewDelegate {
    
    private var colorado: MGLCoordinateBounds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // Denver, Colorado
        let center = CLLocationCoordinate2D(latitude: 39.748947, longitude: -104.995882)
        
        // Starting point.
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)
        
        // Colorado's bounds
        let ne = CLLocationCoordinate2D(latitude: 40.989329, longitude: -102.062592)
        let sw = CLLocationCoordinate2D(latitude: 36.986207, longitude: -109.049896)
        colorado = MGLCoordinateBoundsMake(sw, ne)
        
        view.addSubview(mapView)

    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        
        // Get current coordinates
        let visibleCoordinateBounds: MGLCoordinateBounds = mapView.visibleCoordinateBounds
        let newCameraCenter: CLLocationCoordinate2D = newCamera.centerCoordinate
        let oldCameraCenter: CLLocationCoordinate2D = oldCamera.centerCoordinate
        
        // Get the offset from old camera center to current visible map bounds
        let neLatitudeOffset: CLLocationDegrees = visibleCoordinateBounds.ne.latitude - oldCameraCenter.latitude
        let neLongitudeOffset: CLLocationDegrees = visibleCoordinateBounds.ne.longitude - oldCameraCenter.longitude
        let swLatitudeOffset: CLLocationDegrees = visibleCoordinateBounds.sw.latitude - oldCameraCenter.latitude
        let swLongitudeOffset: CLLocationDegrees = visibleCoordinateBounds.sw.longitude - oldCameraCenter.longitude
        
        // Update the boundaries with new camera center + boundary offset
        let newNE: CLLocationCoordinate2D = CLLocationCoordinate2DMake(neLatitudeOffset + newCameraCenter.latitude, neLongitudeOffset + newCameraCenter.longitude)
        
        let newSW: CLLocationCoordinate2D = CLLocationCoordinate2DMake(swLatitudeOffset + newCameraCenter.latitude, swLongitudeOffset + newCameraCenter.longitude)
        let newBounds: MGLCoordinateBounds = MGLCoordinateBoundsMake(newSW, newNE)
        
        // Test if the new camera center point and boundaries are inside colorado
        let inside: Bool = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado)
        let intersects: Bool = MGLCoordinateInCoordinateBounds(newBounds.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newBounds.sw, self.colorado)
        
        return inside && intersects

    }
}
