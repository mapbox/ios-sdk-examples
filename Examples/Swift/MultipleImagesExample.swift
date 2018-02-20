
import Mapbox

@objc(MultipleImagesExample_Swift)

class MultipleImagesExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL())
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.7456, longitude: -119.5936), zoomLevel: 14, animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self
        view.addSubview(mapView)
    }

}
