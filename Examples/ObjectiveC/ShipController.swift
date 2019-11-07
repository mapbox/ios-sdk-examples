import UIKit
import Mapbox

class ShipController: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    var limitingBounds = MGLCoordinateBounds(
        sw: CLLocationCoordinate2D(latitude: -40.0781, longitude: -77.4316),
        ne: CLLocationCoordinate2D(latitude: -25.7405, longitude: -65.8301)
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: self.view.frame)
        mapView.setCenter(CLLocationCoordinate2D(latitude: -33.5048, longitude: -70.7739), zoomLevel: 6, animated: false)
        view.addSubview(mapView)
        mapView.delegate = self

        let coordinates = [
            CLLocationCoordinate2D(latitude: -37.99616267972812, longitude: -71.6748046875),
            CLLocationCoordinate2D(latitude: -37.99616267972812, longitude: -69.93896484375),
            CLLocationCoordinate2D(latitude: -27.508271413876017, longitude: -69.93896484375),
            CLLocationCoordinate2D(latitude: -27.508271413876017, longitude: -71.6748046875),
            CLLocationCoordinate2D(latitude: -37.99616267972812, longitude: -71.6748046875)
        ]

        let rectangle = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))

        mapView.addAnnotation(rectangle)

        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = false

        let verticalSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(verticalSwipeHandler))

        for recognizer in mapView.gestureRecognizers! where recognizer is UIPanGestureRecognizer {
            verticalSwipeGesture.require(toFail: recognizer)
        }

        mapView.addGestureRecognizer(verticalSwipeGesture)
    }

    @objc func verticalSwipeHandler(_ gestureRecognizer: UIPanGestureRecognizer) {

        let currentCenterScreenPoint = mapView.convert(mapView.centerCoordinate, toPointTo: mapView)
        let yDelta = gestureRecognizer.translation(in: mapView).y
        let newCenterScreenPoint = CGPoint(x: currentCenterScreenPoint.x, y: currentCenterScreenPoint.y + yDelta)
        let newCenterCoordinate = mapView.convert(newCenterScreenPoint, toCoordinateFrom: mapView)
        let projectedCamera = MGLMapCamera(lookingAtCenter: newCenterCoordinate, acrossDistance: mapView.camera.viewingDistance, pitch: mapView.camera.pitch, heading: mapView.camera.heading)

        if mapView(mapView, shouldChangeFrom: mapView.camera, to: projectedCamera) {
            mapView.setCenter(newCenterCoordinate, animated: false)
        }
    }

    // Restrict the bounds of the map just slightly outside of the area of interest
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {

        let currentCamera = mapView.camera
        let newCameraCenter = newCamera.centerCoordinate
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        mapView.camera = currentCamera

        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.limitingBounds)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.limitingBounds) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.limitingBounds)

        return inside && intersects
    }
}
