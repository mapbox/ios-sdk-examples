import Mapbox

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let pointFeature = MGLPointFeature()
        pointFeature.coordinate = mapView.centerCoordinate
        
        let source = MGLShapeSource(identifier: "symbol-source", shape: pointFeature, options: nil)
        let symbol = MGLSymbolStyleLayer(identifier: "point", source: source)
        symbol.text = NSExpression(forConstantValue: "HELLO WORLD")
        symbol.textFontSize = NSExpression(forConstantValue: 52.0)
        symbol.textHaloBlur = NSExpression(forConstantValue: 15.0)
        symbol.textHaloColor = NSExpression(forConstantValue: UIColor.red)
        style.addSource(source)
        style.addLayer(symbol)
    }
}
