
import Mapbox

@objc(CircleLayerTransitionExample_Swift)

class CircleLayerTransitionExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new map view using the Mapbox Outdoors style.
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.outdoorsStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.437, longitude: -81.91), animated: false)
        mapView.zoomLevel = 6
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
}
