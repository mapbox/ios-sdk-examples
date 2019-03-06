import Mapbox
import Turf

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.7736, longitude: -122.4342), zoomLevel: 16, animated: false)
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        let circle = MGLCircle(center: mapView.centerCoordinate, distance: 100)
        let source = MGLShapeSource(identifier: "circle-source", shape: circle, options: nil)
        let layer = MGLFillStyleLayer(identifier: "circle-style", source: source)
        layer.fillOpacity = NSExpression(forConstantValue: 0.5)
        layer.fillColor = NSExpression(forConstantValue: UIColor.red)

        style.addSource(source)
        style.addLayer(layer)
    }

    func MGLCircle(center: CLLocationCoordinate2D, distance: CLLocationDistance) -> MGLPolygon {
        let step = 64
        var circleCoordinates = [CLLocationCoordinate2D]()

        _ = (0...step).map {
            let bearing = $0 * -360 / step
            circleCoordinates.append(center.coordinate(at: distance, facing: CLLocationDirection(bearing)))
        }

        return MGLPolygon(coordinates: circleCoordinates, count: UInt(circleCoordinates.count))
    }
}
