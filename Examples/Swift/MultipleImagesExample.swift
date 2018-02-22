
import Mapbox

@objc(MultipleImagesExample_Swift)

class MultipleImagesExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL())
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.7, longitude: -119.7), zoomLevel: 10, animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let url = URL(string: "mapbox://jordankiley.asry9k5m") {
            let source = MGLVectorSource(identifier: "yosemite-pois", configurationURL: url)
            style.addSource(source)
//            if let outdoorLayer = style.
            print(style.layers)
            let layer = MGLSymbolStyleLayer(identifier: "yosemite-pois", source: source)
            layer.sourceLayerIdentifier = "Yosemite_POI-8mmqrb"
//            layer.predicate = NSPredicate(format: "station = 'Kenai NWR'")
            let imageDictionary = [ "Picnic Area" : "picnic-site-15"]
            layer.iconImageName = NSExpression(format: "TERNARY(FUNCTION(%@, 'valueForKeyPath:', POITYPE) != nil, FUNCTION(%@, 'valueForKeyPath:', POITYPE))", imageDictionary, "circle-15")
//            layer.text = NSExpression(forKeyPath: "POITYPE")
            style.addLayer(layer)
        }
    }

}
