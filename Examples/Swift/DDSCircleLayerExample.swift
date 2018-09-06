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

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.897, longitude: -77.039), animated: false)
        mapView.zoomLevel = 10.5

        mapView.delegate = self
        view.addSubview(mapView)
    }

    // Wait until the style is loaded before modifying the map style.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        // Upgrade the Podfile to 4.3.0 to reproduce the issues.
        // This filters properly on 4.0.0

        let pointA = MGLPointFeature()
        pointA.coordinate = CLLocationCoordinate2DMake(38.897, -77.039)
        pointA.attributes = ["rowindex": 1]

        let pointB = MGLPointFeature()
        pointB.coordinate = CLLocationCoordinate2DMake(38.9, -77.0)
        pointB.attributes = ["rowindex": 2]

        let shapeSource = MGLShapeSource(identifier: "shapes", features: [pointA, pointB], options: nil)

        // Using circle layer for easier visibility
        let layer = MGLCircleStyleLayer(identifier: "shapes-style", source: shapeSource)
        layer.circleRadius = NSExpression(forConstantValue: 5)
        layer.circleColor = NSExpression(forConstantValue: UIColor.red)

        let filter: Set<Int> = [1,3,5]
        layer.predicate = NSPredicate(format: "ANY %K IN %@", "rowindex", filter)

        style.addSource(shapeSource)
        style.addLayer(layer)
    }
}
