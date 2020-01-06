import Mapbox

@objc(OrnamentsLayoutExample_Swift)
class OrnamentsLayoutExample_Swift: UIViewController, MGLMapViewDelegate {
    private var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initializing map view and setting center.
        mapView = MGLMapView(frame: view.bounds)
        mapView.setCenter(CLLocationCoordinate2DMake(39.915143, 116.404053), zoomLevel: 16, direction: 30, animated: false)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Configure mapView to show the scale and always display the compass.
        mapView.delegate = self
        mapView.showsScale = true
        mapView.compassView.compassVisibility = .visible
        
        // Set positions of various ornaments using the `MGLOrnamentPosition` enum.
        // NOTE: You can be more prescriptive about where the ornaments are positioned by using
        // the `scaleBarMargins` , `compassViewMargins`, `logoViewMargins` and `attributionButtonMargins` properties.
        mapView.scaleBarPosition = .topRight
        mapView.compassViewPosition = .topLeft
        mapView.logoViewPosition = .bottomRight
        mapView.attributionButtonPosition = .bottomLeft

        view.addSubview(mapView)
    }
}
