//import Mapbox
//
//@objc(CustomCalloutViewExample_Swift)
//
//class CustomCalloutViewExample_Swift: UIViewController, MGLMapViewDelegate {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL())
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.tintColor = .darkGray
//        view.addSubview(mapView)
//        
//        // Set the map view‘s delegate property.
//        mapView.delegate = self
//        
//        // Initialize and add the marker annotation.
//        let marker = MGLPointAnnotation()
//        marker.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//        marker.title = "Hello world!"
//        
//        // This custom callout example does not implement subtitles.
//        //marker.subtitle = "Welcome to my marker"
//        
//        // Add marker to the map.
//        mapView.addAnnotation(marker)
//
//        // Select the annotation so the callout will appear.
//        mapView.selectAnnotation(marker, animated: false)
//    }
//    
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        // Only show callouts for `Hello world!` annotation.
//        return annotation.responds(to: #selector(getter: MGLAnnotation.title)) && annotation.title! == "Hello world!"
//    }
//
//    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
//        // Instantiate and return our custom callout view.
//        return CustomCalloutView(representedObject: annotation)
//    }
//    
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        // Optionally handle taps on the callout.
//        print("Tapped the callout for: \(annotation)")
//        
//        // Hide the callout.
//        mapView.deselectAnnotation(annotation, animated: true)
//    }
//}

