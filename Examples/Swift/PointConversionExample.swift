import Mapbox

@objc(PointConversionExample_Swift)

class PointConversionExample_Swift: UIViewController {
    var mapView: MGLMapView!
    var singleTap: UIGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        singleTap.delegate = self

        mapView.addGestureRecognizer(singleTap)

        // Convert `mapView.centerCoordinate` (CLLocationCoordinate2D) to screen location (CGPoint).
        let centerScreenPoint: CGPoint = mapView.convert(mapView.centerCoordinate, toPointTo: nil)
        print("Screen center: \(centerScreenPoint) = \(mapView.center)")
    }

    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
        let tapPoint: CGPoint = sender.location(in: mapView)
        let tapCoordinate: CLLocationCoordinate2D = mapView.convert(tapPoint, toCoordinateFrom: nil)
        print("You tapped at: \(tapCoordinate.latitude), \(tapCoordinate.longitude)")

        // Create an array of coordinates for our polyline, starting at the center of the map and ending at the tap coordinate.
        var coordinates: [CLLocationCoordinate2D] = [mapView.centerCoordinate, tapCoordinate]

        // Remove any existing polyline(s) from the map.
        if mapView.annotations?.count != nil, let existingAnnotations = mapView.annotations {
            mapView.removeAnnotations(existingAnnotations)
        }

        // Add a polyline with the new coordinates.
        let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.addAnnotation(polyline)
    }
}

extension PointConversionExample_Swift: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // Sanity check
        guard
            (gestureRecognizer != otherGestureRecognizer) &&
            (gestureRecognizer == singleTap) else {
                fatalError()
        }

        // We're only interested in the other tap gestures installed on the MGLMapView
        guard
            let otherTapGestureRecognizer = otherGestureRecognizer as? UITapGestureRecognizer,
            otherTapGestureRecognizer.view == self.mapView else {
                return false
        }

        /*
        // Check number of taps
        let otherGestureShouldFail = (otherTapGestureRecognizer.numberOfTapsRequired == 1)
        return otherGestureShouldFail
        */
        
        return true
    }
}
