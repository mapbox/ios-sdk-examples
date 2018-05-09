import Mapbox;

@objc(MultipleShapesExample_Swift)

class MultipleShapesExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        mapView.setCenter(CLLocationCoordinate2D(latitude:36.932804264700003, longitude: -76.296154697199995), zoomLevel: 12, animated: false)
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Parse the GeoJSON data.
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "metro-line", withExtension: "geojson") else { return }

            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.drawShapeCollection(data: data)
            }
        }
    }
    
    func drawShapeCollection(data: Data) {
        guard let style = self.mapView.style else { return }
        
        // Use [MGLShape shapeWithData:encoding:error:] to create a MGLShapeCollectionFeature from GeoJSON data.
        let feature = try! MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as! MGLPolylineFeature
        
        // Create source and add it to the map style.
        let source = MGLShapeSource(identifier: "line-source", shape: feature, options: nil)
        style.addSource(source)
        
        // Create line style layer.
        let lineLayer = MGLLineStyleLayer(identifier: "line", source: source)
        
        // This is what the properties look like
        // for the GeoJSON
        
//        "properties":{
//            "lineStyle":{
//                "color":"#00ffff",
//                "opacity":1,
//                "weight":1
//            },
//            "polyStyle":{
//                "fillOpacity":0,
//                "weight":1,
//                "fillColor":"#00ffff",
//                "opacity":1,
//                "color":"#00ffff"
//            },
//            "pointStyle":{
//                "radius":7,
//                "weight":0.5,
//                "opacity":1,
//                "color":"#00ffff"
//            }
//        }
//
        lineLayer.lineColor = NSExpression(format: "CAST(lineStyle.color, 'UIColor')")
        
        lineLayer.lineWidth = NSExpression(forConstantValue: 2)
        
        // Add style layers to the map view's style.
        style.addLayer(lineLayer)
    }
}
