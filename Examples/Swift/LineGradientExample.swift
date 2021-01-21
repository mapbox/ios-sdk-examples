import UIKit
import Mapbox
@objc(LineGradientExample_Swift)

class LineGradientExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.875, longitude: -77.035), zoomLevel: 12, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        drawPolyline()
    }
    
    func drawPolyline() {
        // Since we know this file exists within this project, we'll force unwrap its value.
        // If this data was coming from an external server, we would want to perform
        // proper error handling for a web request/response.
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "iOSLineGeoJSON", ofType: "geojson")!)
        guard let jsonData = try? Data(contentsOf: url) else {
            preconditionFailure("Failed to parse GeoJSON file")
        }
        // Add our GeoJSON data to the map as an MGLShapeSource.
        // We can then reference this data from an MGLStyleLayer.
        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView.style else { return }
        guard let shapeFromGeoJSON = try? MGLShape(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: "polyline", shape: shapeFromGeoJSON, options: [MGLShapeSourceOption.lineDistanceMetrics: true])
        style.addSource(source)
        // Create a new style layer for the line which will determine the line's styling properties.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        // Set the line join and cap to a rounded end.
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        
        let stops = [0: UIColor.blue,
                     0.1: UIColor.purple,
                     0.3: UIColor.cyan,
                     0.5: UIColor.green,
                     0.7: UIColor.yellow,
                     1: UIColor.red]
        
        // Set the line color to a gradient
        layer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops)
        
        // Use `NSExpression` to allow the appearance of your gradient to change and become more detailed with the map’s zoom level
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 10, 18: 20])
        
        style.addLayer(layer)
    }
}
