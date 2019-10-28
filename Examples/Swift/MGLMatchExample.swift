import UIKit
import Mapbox

@objc(MGLMatchExample_Swift)

class MGLMatchExample_Swift: UIViewController, MGLMapViewDelegate {
    var source: MGLShapeSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 36.851, longitude: -119.448)
        mapView.zoomLevel = 5
        // Set the map view‘s delegate property.
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Add our GroJSON source to the map.
        if let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson") {
        let source = MGLShapeSource(identifier: "earthquakes", url: url, options: nil)
        style.addSource(source)
        //set default values for color, opacity and radius
        let defaultColor = UIColor.blue
        let defaultRadius = NSExpression(forConstantValue: 3)
        let defaultOpacity = NSExpression(forConstantValue: 0.5)
        let layer = MGLCircleStyleLayer(identifier: "earthquakes", source: source)
        // Style the circle layer color, opacity and radius based on type.
        layer.circleColor = NSExpression(format: "MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)", UIColor.magenta, UIColor.systemPink, UIColor.systemPurple, defaultColor)
        layer.circleOpacity = NSExpression(format: "MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)",NSExpression(forConstantValue: 0.3), NSExpression(forConstantValue: 0.3), NSExpression(forConstantValue: 0.2), defaultOpacity)
        layer.circleRadius = NSExpression(format: "MGL_MATCH(type, 'earthquake', %@, 'explosion', %@, 'quarry blast', %@, %@)",
        NSExpression(forConstantValue: 3), NSExpression(forConstantValue: 6), NSExpression(forConstantValue: 9), defaultRadius)
        layer.circleStrokeColor = NSExpression(forConstantValue: UIColor.darkGray)
        layer.circleStrokeWidth = NSExpression(forConstantValue: 1)
        style.addLayer(layer)
        }
    }
}
