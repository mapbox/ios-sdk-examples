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

        // Starting point
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)

        // Colorado’s bounds
        let northeast = CLLocationCoordinate2D(latitude: 40.989329, longitude: -102.062592)
        let southwest = CLLocationCoordinate2D(latitude: 36.986207, longitude: -109.049896)
        colorado = MGLCoordinateBounds(sw: southwest, ne: northeast)

        view.addSubview(mapView)
    }

    // This example uses Colorado’s boundaries to restrict the camera movement.
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {

        // Get the current camera to restore it after.
        let currentCamera = mapView.camera

        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate

        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds

        // Revert the camera.
        mapView.camera = currentCamera

        // Test if the newCameraCenter and newVisibleCoordinates are inside self.colorado.
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.colorado)

        return inside && intersects
    }
}
