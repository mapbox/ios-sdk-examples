import Mapbox

@objc(ThirdPartyVectorStyleExample_Swift)

class ThirdPartyVectorStyleExample_Swift: UIViewController {
    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Third party vector tile sources can be added.

        // In this case we're using custom style JSON (https://www.mapbox.com/mapbox-gl-style-spec/) to add a third party tile source from Mapillary: <https://d25uarhxywzl1j.cloudfront.net/v0.1/{z}/{x}/{y}.mvt>
        let customStyleURL = Bundle.main.url(forResource: "third_party_vector_style", withExtension: "json")!

        mapView = MGLMapView(frame: view.bounds, styleURL: customStyleURL)
        mapView.setCenter(CLLocationCoordinate2DMake(60.16, 24.93), zoomLevel: 12, animated: false)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .white

        // Set the minimum zoom level to prevent the map from zooming out past zoom level 6.
        mapView.minimumZoomLevel = 6

        view.addSubview(mapView)
    }
}
