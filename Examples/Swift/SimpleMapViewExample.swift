import Mapbox

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let currentVisibleBounds = mapView.visibleCoordinateBounds

        print("VISIBLE COORDINATE BOUNDS:")
        print("SW: \(currentVisibleBounds.sw)")
        print("NE: \(currentVisibleBounds.ne)")
    }
}
