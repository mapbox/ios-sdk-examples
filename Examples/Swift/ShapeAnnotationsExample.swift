import UIKit
import Mapbox

@objc(ShapeAnnotationsExample_Swift)

class ShapeAnnotationsExample_Swift: UIViewController {

    var pointCoordinate: CLLocationCoordinate2D!
    var lineCoordinates = [CLLocationCoordinate2D]()
    var polygonCoordinates = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: self.view.frame)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.520, longitude: -122.668), zoomLevel: 13, animated: false)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Allow this ViewController class to be the reciever of `MGLMapViewDelegate` events.
        mapView.delegate = self
        view.addSubview(mapView)

        setupCoordinates()

        // Three shapes annotations are created below: a point, line, and a polygon.
        let pointAnnnotation = MGLPointAnnotation()
        pointAnnnotation.coordinate = pointCoordinate
        // This text will appear in the callout when the
        // shape is selected.
        pointAnnnotation.title = "Event venue"

        let lineAnnotation = MGLPolyline(coordinates: lineCoordinates, count: UInt(lineCoordinates.count))
        lineAnnotation.title = "Parade route"

        let polygonAnnotation = MGLPolygon(coordinates: polygonCoordinates, count: UInt(polygonCoordinates.count))
        polygonAnnotation.title = "Limited parking"

        // Add all three annotations to the map.
        mapView.addAnnotations([pointAnnnotation, lineAnnotation, polygonAnnotation])
    }

    func setupCoordinates() {
        pointCoordinate = CLLocationCoordinate2D(latitude: 45.531, longitude: -122.666)

        lineCoordinates = [
          CLLocationCoordinate2D(latitude: 45.526, longitude: -122.677),
          CLLocationCoordinate2D(latitude: 45.523, longitude: -122.677),
          CLLocationCoordinate2D(latitude: 45.523, longitude: -122.674),
          CLLocationCoordinate2D(latitude: 45.522, longitude: -122.674),
          CLLocationCoordinate2D(latitude: 45.518, longitude: -122.676),
          CLLocationCoordinate2D(latitude: 45.517, longitude: -122.673),
          CLLocationCoordinate2D(latitude: 45.513, longitude: -122.676)
        ]

        polygonCoordinates = [
          CLLocationCoordinate2D(latitude: 45.512, longitude: -122.663),
          CLLocationCoordinate2D(latitude: 45.512, longitude: -122.654),
          CLLocationCoordinate2D(latitude: 45.522, longitude: -122.654),
          CLLocationCoordinate2D(latitude: 45.522, longitude: -122.663),
          CLLocationCoordinate2D(latitude: 45.512, longitude: -122.663)
        ]
    }
}

extension ShapeAnnotationsExample_Swift: MGLMapViewDelegate {
    // Allows callouts to be displayed when the annotation is selected.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    // Assigns a fill color for the polygon annotation.
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 1.00, green: 0.96, blue: 0.00, alpha: 0.4)
    }

    // Assigns a stroke or "outline" color for non-point annotations.
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor(red: 0.00, green: 0.46, blue: 1.00, alpha: 1.0)
    }

    // Assigns a width for to the line annotation.
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return 8.0
    }
}
