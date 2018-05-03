import Mapbox

@objc(DDSCircleLayerExample_Swift)

class DDSCircleLayerExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new map view using the Mapbox Light style.
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray

        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    // Wait until the style is loaded before modifying the map style.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson")!
        let symbolSource = MGLSource(identifier: "source")
        let symbolLayer = MGLSymbolStyleLayer(identifier: "place-city-sm", source: symbolSource)
        
        let source = MGLShapeSource(identifier: "earthquakes", url: url, options: nil)
        mapView.style?.addSource(source)
        
        let stops = [
            "earthquake": UIColor.orange,
            "explosion": UIColor.red,
            "quarry blast": UIColor.yellow
        ]
        
        let layer = MGLCircleStyleLayer(identifier: "circles", source: source)
//        layer.circleColor = NSExpression(forFunction: "FUNCTION(%@, 'valueForKeyPath:', myAttribute)", arguments: stops)
//        layer.circleColor = NSExpression(forFunction: "%@, 'valueForKeyPath:', myAttribute", arguments: stops)
//        layer.circleColor = NSExpression(forFunction: "%@, 'valueForKeyPath:', myAttribute", stops)
//        layer.circleColor = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', type)", arguments: stops)
//        layer.circleColor = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', type)", argumentArray: [stops])
        layer.circleColor = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', type)", stops)

        mapView.style?.insertLayer(layer, below: symbolLayer)
        
        
    }
}
