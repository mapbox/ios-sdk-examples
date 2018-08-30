import Mapbox

@objc(StudioStyleExample_Swift)

class StudioStyleExample_Swift: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace the string in the URL below with your custom style URL from Mapbox Studio.
        // Read more about style URLs here: https://www.mapbox.com/help/define-style-url/
        let styleURL = URL(string: "mapbox://styles/mapbox/outdoors-v9")
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.52954,
                longitude: -122.72317),
                zoomLevel: 14, animated: false)
        view.addSubview(mapView)
    }
}
