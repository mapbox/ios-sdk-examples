
import Mapbox

@objc(CircleLayerTransitionExample_Swift)

class CircleLayerTransitionExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new map view using the Mapbox Outdoors style.
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.outdoorsStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.437, longitude: -81.91), animated: false)
        mapView.zoomLevel = 6
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    // Wait for the primary MapView to load before adding Circles & Interactions
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Initialize circle coordinates
        let coordinates = [
            CLLocationCoordinate2D(latitude: 30.3326, longitude: -81.6559),
            CLLocationCoordinate2D(latitude: 27.9483, longitude: -82.4578),
            CLLocationCoordinate2D(latitude: 25.7752, longitude: -80.1947),
            ]
        
        // Turn coordinates into PointAnnotations
        var circleFeatures = [MGLPointFeature]()
        for coordinate in coordinates {
            let circle = MGLPointFeature()
            circle.coordinate = coordinate
            circleFeatures.append(circle)
        }
        
        // Turn this feature array into a source object and add it to the map
        let dataSource = MGLShapeSource(identifier: "mainCircles", features: circleFeatures)
        style.addSource(dataSource)
        
        // Use the circle PointAnnotations to create a CircleStyleLayer
        let circlesLayer = MGLCircleStyleLayer(identifier: "mainCircles", source: dataSource)
        circlesLayer.circleRadius = NSExpression(forConstantValue: 8)
        circlesLayer.circleOpacity = NSExpression(forConstantValue: 1)
        circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.75))
        circlesLayer.circleColor = NSExpression(forConstantValue: UIColor(red: 1, green: 0.8, blue: 0, alpha: 1.0))
        
        style.addLayer(circlesLayer)
        
        
    }
}
