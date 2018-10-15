import Mapbox

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL:URL(string: "mapbox://styles/mapbox/cj44mfrt20f082snokim4ungi"))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.delegate = self;
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let cityLabels = style.layer(withIdentifier: "place-city-lg-s") as! MGLSymbolStyleLayer
        
        let fontExpression = NSExpression(format: "{'Roboto Medium Italic'}")
        
        cityLabels.textFontNames = fontExpression
        
        cityLabels.textColor = NSExpression(forConstantValue: UIColor.red)
        
    }
}
