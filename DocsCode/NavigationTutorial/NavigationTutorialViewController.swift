// #-code-snippet: navigation dependencies-swift
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
// #-end-code-snippet: navigation dependencies-swift

class ViewController: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    // #-code-snippet: navigation directions-route-swift
    var directionsRoute: Route?
    // #-end-code-snippet: navigation directions-route-swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #-code-snippet: navigation init-map-swift
        mapView = NavigationMapView(frame: view.bounds)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 30.265, longitude: -97.741), zoomLevel: 11, animated: false)
        view.addSubview(mapView)
        // Set the map view's delegate
        mapView.delegate = self
        // #-end-code-snippet: navigation init-map-swift
        
        // #-code-snippet: navigation user-location-swift
        // Allow the map view to display the user's location
        mapView.showsUserLocation = true
        // #-end-code-snippet: navigation user-location-swift
        
        // #-code-snippet: navigation gesture-recognizer-swift
        // Add a gesture recognizer to the map view
        let setDestination = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(setDestination)
        // #-end-code-snippet: navigation gesture-recognizer-swift
    }
    
    // #-code-snippet: navigation allow-callouts-swift
    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    // #-end-code-snippet: navigation allow-callouts-swift
    
    // #-code-snippet: navigation long-press-swift
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        
        // Calcuate the route from the user's location to the set destination
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                NSLog("Error calculating route: \(String(describing: error))")
            }
        }
    }
    // #-end-code-snippet: navigation long-press-swift
    
    // #-code-snippet: navigation calculate-route-swift
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intented for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    // #-end-code-snippet: navigation calculate-route-swift
    
    // #-code-snippet: navigation draw-route-swift
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)

            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = MGLStyleValue(rawValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = MGLStyleValue(rawValue: 3)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    // #-end-code-snippet: navigation draw-route-swift
    
    // #-code-snippet: navigation tap-callout-swift
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
    }
    // #-end-code-snippet: navigation tap-callout-swift
}

