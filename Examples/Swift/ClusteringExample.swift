import Mapbox

@objc(ClusteringExample_Swift)

class ClusteringExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var icon: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.delegate = self
        view.addSubview(mapView)

        icon = UIImage(named: "port")
        
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)

        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: [.clustered: true, .clusterRadius: icon.size.width])
        style.addSource(source)
        
        
        // LABELS FOR CLUSTERS
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        
        // CLUSTER STYLING
        
        style.setImage(UIImage(named: "circle")!, forName: "circle")
        style.setImage(UIImage(named: "rectangle")!, forName: "rectangle")
        style.setImage(UIImage(named: "star")!, forName: "star")
        style.setImage(UIImage(named: "polygon")!, forName: "polygon")
        
        let stops = [
            20:  NSExpression(forConstantValue: "circle"),
            50:  NSExpression(forConstantValue: "rectangle"),
            100: NSExpression(forConstantValue: "star"),
            200: NSExpression(forConstantValue: "polygon")
        ]
        
        let defaultStar = NSExpression(forConstantValue: "star")
        numbersLayer.iconImageName = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", defaultStar, stops)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        
        // UNCLUSTERED STYLING

        style.setImage(icon.withRenderingMode(.alwaysTemplate), forName: "icon")
        
        let ports = MGLSymbolStyleLayer(identifier: "ports", source: source)
        ports.iconImageName = NSExpression(forConstantValue: "port")
        ports.iconColor = NSExpression(forConstantValue: UIColor.darkGray.withAlphaComponent(0.9))
        ports.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(ports)
        
        numbersLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(numbersLayer)
    }
}
