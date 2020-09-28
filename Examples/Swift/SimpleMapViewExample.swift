import Mapbox

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)

        let annotation = MGLPointAnnotation() // Annotation is being added to the map at this point?
        annotation.coordinate = mapView.centerCoordinate
//        mapView.addAnnotation(annotation)

        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
                mapView.selectAnnotation(annotation, animated: false, completionHandler: nil)
                
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("Annotation selected")
    }
}
