import Mapbox

@objc(ClusteringWithImagesExample_Swift)

class ClusteringWithImagesExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var icon: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Map
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
        
        icon = UIImage(named: "circle")
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Retrieve data and set as style layer source
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: [.clustered: true, .clusterRadius: icon.size.width])
        style.addSource(source)
        
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        
        
        // Style clusters
        style.setImage(UIImage(named: "circle")!, forName: "circle")
        style.setImage(UIImage(named: "rectangle")!, forName: "rectangle")
        style.setImage(UIImage(named: "cloud")!, forName: "cloud")
        style.setImage(UIImage(named: "oval")!, forName: "oval")
        
        let stops = [
            10:  NSExpression(forConstantValue: "circle"),
            25:  NSExpression(forConstantValue: "rectangle"),
            75: NSExpression(forConstantValue: "cloud"),
            150: NSExpression(forConstantValue: "oval")
        ]
        
        let defaultCircle = NSExpression(forConstantValue: "circle")
        numbersLayer.iconImageName = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", defaultCircle, stops)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        
        style.addLayer(numbersLayer)
    }

}
