import UIKit
import Mapbox

class PolygonAnimationViewController: UIViewController, MGLMapViewDelegate, CAAnimationDelegate {

    var mapView: MGLMapView!
    var shapeLayer = CAShapeLayer()
    var polygon = MGLPolygon(coordinates: startingPolygonCoordinates, count: UInt(startingPolygonCoordinates.count))
    var polygonSource: MGLShapeSource!
    var polygonLayer: MGLFillStyleLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: self.view.frame, styleURL: MGLStyle.lightStyleURL)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 18, longitude: -30)
        mapView.zoomLevel = 1
        self.view.addSubview(mapView)
        mapView.delegate = self
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        polygonSource = MGLShapeSource(identifier: "start-source", shape: polygon, options: nil)
        polygonLayer = MGLFillStyleLayer(identifier: "start-style", source: polygonSource)
        polygonLayer.fillColor = NSExpression(forConstantValue: UIColor.green)

        style.addSource(polygonSource)
        style.addLayer(polygonLayer)

        let firstPath = generateShapePath(for: mapView, coordinates: startingPolygonCoordinates)
        let secondPath = generateShapePath(for: mapView, coordinates: endingPolygonCoordinates)

        shapeLayer.path = firstPath.cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(shapeLayer)

        animatePath(from: firstPath.cgPath, to: secondPath.cgPath, for: shapeLayer)
    }

    func generateShapePath(for mapView: MGLMapView, coordinates: [CLLocationCoordinate2D]) -> UIBezierPath {
        let path = UIBezierPath()

        // Starting point
        let startingPoint =  mapView.convert(coordinates[0], toPointTo: mapView)

        path.move(to: startingPoint)

        // Rest of the points
        _ = coordinates.map {
            let screenPoint = mapView.convert($0, toPointTo: mapView)
            path.addLine(to: screenPoint)
        }

        path.close()

        return path
    }

    func animatePath(from startingValue: CGPath, to endingValue: CGPath, for layer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = startingValue
        layer.path = endingValue
        pathAnimation.duration = 3
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        layer.add(pathAnimation, forKey: "pathAnimation")
    }

    public func animationDidStart(_ anim: CAAnimation) {
        polygonLayer.isVisible = false
        mapView.isUserInteractionEnabled = false
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        shapeLayer.removeAllAnimations()
        shapeLayer.removeFromSuperlayer()
        let endingPolygon = MGLPolygon(coordinates: endingPolygonCoordinates, count: UInt(endingPolygonCoordinates.count))
        polygonSource.shape? = endingPolygon
        polygonLayer.isVisible = true
        mapView.isUserInteractionEnabled = true
    }
}

let startingPolygonCoordinates = [
    CLLocationCoordinate2D(latitude: 31.80289258670676, longitude: -49.5703125),
    CLLocationCoordinate2D(latitude: 31.80289258670676, longitude: -22.8515625),
    CLLocationCoordinate2D(latitude: 50.736455137010665, longitude: -22.8515625),
    CLLocationCoordinate2D(latitude: 50.736455137010665, longitude: -49.5703125),
    CLLocationCoordinate2D(latitude: 31.80289258670676, longitude: -49.5703125)
]

let endingPolygonCoordinates = [
    CLLocationCoordinate2D(latitude: 31.80289258670676, longitude: -17.75390625),
    CLLocationCoordinate2D(latitude: 31.87755764334002, longitude: 3.6035156249999996),
    CLLocationCoordinate2D(latitude: 50.90303283111257, longitude: 14.150390625),
    CLLocationCoordinate2D(latitude: 50.90303283111257, longitude: -9.31640625),
    CLLocationCoordinate2D(latitude: 31.80289258670676, longitude: -17.75390625)
]
