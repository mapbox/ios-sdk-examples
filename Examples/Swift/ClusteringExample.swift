import Mapbox

@objc(ClusteringExample_Swift)

class ClusteringExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var portIcon: UIImage!
    var cameraIcon: UIImage!
    var popup: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.setCenter(CLLocationCoordinate2D(latitude: 53.74361111, longitude: -0.285100118), animated: false)
        mapView.zoomLevel = 9
        mapView.delegate = self
        view.addSubview(mapView)

        portIcon = UIImage(named: "port")
        cameraIcon = UIImage(named: "camera")
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)

        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: nil)
        style.addSource(source)

        // Use a template image so that we can tint it with the `iconColor` runtime styling property.
        style.setImage(portIcon.withRenderingMode(.alwaysTemplate), forName: "icon")
        style.setImage(cameraIcon.withRenderingMode(.alwaysOriginal), forName: "camera")

        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
        let ports = MGLSymbolStyleLayer(identifier: "ports", source: source)
        
        let iconImageStops = [
            "Port": NSExpression(forConstantValue: "icon"),
            "Camera": NSExpression(forConstantValue: "camera")
        ]
        
        ports.iconImageName  = NSExpression(
            format: "TERNARY(FUNCTION(%@, 'valueForKeyPath:', featureclass) != nil, FUNCTION(%@, 'valueForKeyPath:', featureclass), %@)",
            iconImageStops, iconImageStops, NSExpression(forConstantValue: "rocket-15"))
        
        ports.iconColor = NSExpression(forConstantValue: UIColor.darkGray.withAlphaComponent(0.9))
        style.addLayer(ports)
    }
}
