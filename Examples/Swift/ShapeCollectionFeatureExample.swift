import Mapbox;

@objc(ShapeCollectionFeatureExample_Swift)

class ShapeCollectionFeatureExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL(withVersion: 9)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(CLLocationCoordinate2D(latitude:38.897435, longitude: -77.039679), zoomLevel: 12, animated: false)
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        if let url = URL(string: "https://api.mapbox.com/datasets/v1/mapbox/cj004g2ay04vj2xls3oqdu2ou/features?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpemc0YWlpNzAwcXUyd21ldDV6OWpxMGwifQ.A92RQZpwUgtGtCmdSE4-ow"){
            
            let data = try! Data(contentsOf: url)
            let feature = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLShapeCollectionFeature
            
            // Create source and add it to the map style.
            let source = MGLShapeSource(identifier: "transit", shape: feature, options: nil)
            style.addSource(source)
            
            // Create station style layer.
            let circleLayer = MGLCircleStyleLayer(identifier: "stations", source: source)
            // Use a predicate to filter out non-points.
            circleLayer.predicate = NSPredicate(format: "TYPE = %@", ["Station"])
            circleLayer.circleColor = MGLStyleValue(rawValue: .red)
            circleLayer.circleRadius = MGLStyleValue(rawValue: 6)
            circleLayer.circleStrokeWidth = MGLStyleValue(rawValue: 2)
            circleLayer.circleStrokeColor = MGLStyleValue(rawValue: .black)
            
            // Create line style layer.
            let lineLayer = MGLLineStyleLayer(identifier: "rail-line", source: source)
            // Use a predicate to filter out the stations.
            lineLayer.predicate = NSPredicate(format: "TYPE = %@", argumentArray: ["Rail line"])
            lineLayer.lineColor = MGLStyleValue(rawValue: .red)
            lineLayer.lineWidth = MGLStyleValue(rawValue: 2)
            
            // Add style layers to the map view's style.
            style.addLayer(circleLayer)
            style.insertLayer(lineLayer, below: circleLayer)
        }
    }
}
