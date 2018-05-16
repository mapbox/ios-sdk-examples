import Mapbox

@objc(HillshadeExample_Swift)
class HillshadeExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 63.6304, longitude: -19.6067), zoomLevel: 8, animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.tintColor = .darkGray
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let url = URL(string: "mapbox://mapbox.terrain-rgb") {
            let source = MGLRasterDEMSource(identifier: "terrain-rgb", configurationURL: url)
            style.addSource(source)
            
            let layer = MGLHillshadeStyleLayer(identifier: "terrain-rgb", source: source)
            //            layer.hillshadeAccentColor = NSExpression(forConstantValue: UIColor(red:0.03, green:0.44, blue:0.09, alpha:1.0))
            layer.hillshadeAccentColor = NSExpression(forConstantValue: UIColor.lightGray)
            layer.hillshadeShadowColor = NSExpression(forConstantValue: UIColor.darkGray.withAlphaComponent(0.6))
            layer.hillshadeHighlightColor = NSExpression(forConstantValue: UIColor.lightGray.withAlphaComponent(1.0))
            if let symbolLayer = style.layer(withIdentifier: "waterway-river-canal") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
}
