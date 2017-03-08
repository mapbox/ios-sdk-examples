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
            
            let source = MGLShapeSource.init(identifier: "transit", shape: feature, options: nil)
            
            
            let circleLayer = MGLCircleStyleLayer(identifier: "stations", source: source)
            circleLayer.predicate = NSPredicate(format: "%K == %@", argumentArray: ["TYPE", "Station"])
            circleLayer.circleColor = MGLStyleValue(rawValue: .red)
            circleLayer.circleRadius = MGLStyleValue(rawValue: 6)
            circleLayer.circleStrokeWidth = MGLStyleValue(rawValue: 2)
            circleLayer.circleStrokeColor = MGLStyleValue(rawValue: .black)
            
            let lineLayer = MGLLineStyleLayer(identifier: "rail-line", source: source)
            lineLayer.predicate = NSPredicate(format: "%K == %@", argumentArray: ["TYPE", "Rail line"])
            lineLayer.lineColor = MGLStyleValue(rawValue: .red)
            lineLayer.lineWidth = MGLStyleValue(rawValue: 2)
            
            style.addSource(source)
            style.addLayer(circleLayer)
            style.insertLayer(lineLayer, below: circleLayer)
        }
    }
}
