
import Mapbox

@objc(MultipleImagesExample_Swift)

class MultipleImagesExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL())
        mapView.setCenter(CLLocationCoordinate2D(latitude: 60.0438, longitude: -149.8164), zoomLevel: 10, animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let url = URL(string: "mapbox://jordankiley.9v2hldnp") {
            let source = MGLVectorSource(identifier: "park-feature-points", configurationURL: url)
            style.addSource(source)
            
            let layer = MGLSymbolStyleLayer(identifier: "park-feature-points", source: source)
            layer.sourceLayerIdentifier = "FWS_HQ_NWRS_TrailPts-33isji"
//            layer.predicate = NSPredicate(format: "station = 'Kenai NWR'")
            layer.text = NSExpression(forKeyPath: "type")
            style.addLayer(layer)
        }
    }

}
