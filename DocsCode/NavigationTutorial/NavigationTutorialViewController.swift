// #-code-snippet: navigation full-tutorial-swift
// #-code-snippet: navigation dependencies-swift
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
// #-end-code-snippet: navigation dependencies-swift

class ViewController: UIViewController, MGLMapViewDelegate {
    
    // #-code-snippet: navigation mapview-var-swift
    var mapView: MGLMapView!
    // #-end-code-snippet: navigation mapview-var-swift
    
    // #-code-snippet: navigation directions-route-swift
    var directionsRoute: Route?
    // #-end-code-snippet: navigation directions-route-swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #-code-snippet: navigation init-map-swift
        mapView = NavigationMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL())
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
    func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        
        // #-code-snippet: navigation call-calculate-route-swift
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { [unowned self] (route, error) in
            if error != nil {
                // Print an error message
                print("Error calculating route")
            }
        }
        // #-end-code-snippet: navigation call-calculate-route-swift
    }
    // #-end-code-snippet: navigation long-press-swift
    
    // #-code-snippet: navigation calculate-route-swift
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        let origin = Waypoint(coordinate: origin, name: "Start")
        
        let destination = Waypoint(coordinate: destination, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        _ = Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first else { return }
            self.directionsRoute = route
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    // #-end-code-snippet: navigation calculate-route-swift
    
    // #-code-snippet: navigation draw-route-swift
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline.
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            // #-code-snippet: navigation route-style-swift
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = MGLStyleValue(rawValue:  #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = MGLStyleValue(rawValue: 3)
            // #-end-code-snippet: navigation route-style-swift
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    // #-end-code-snippet: navigation draw-route-swift
    
    // #-code-snippet: navigation present-navigation-swift
    func presentNavigation(along route: Route) {
        class CustomStyle: DayStyle {
            
            public required init() {
                super.init()
                mapStyleURL = URL(string: "mapbox://styles/mapbox/light-v9")!
            }
            
            override func apply() {
                super.apply()
                ManeuverView.appearance().backgroundColor =  #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1)
                RouteTableViewHeaderView.appearance().backgroundColor =  #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1)
                Button.appearance().textColor = .white
                WayNameLabel.appearance().textColor = .white
                DistanceLabel.appearance().textColor = .white
                DestinationLabel.appearance().textColor = .white
                ArrivalTimeLabel.appearance().textColor = .white
                TimeRemainingLabel.appearance().textColor = .white
                DistanceRemainingLabel.appearance().textColor = .white
                TurnArrowView.appearance().primaryColor = .white
                TurnArrowView.appearance().secondaryColor = .white
                LanesView.appearance().backgroundColor = .white
                LaneArrowView.appearance().primaryColor = .white
                CancelButton.appearance().tintColor = .white
            }
        }
        
        let viewController = NavigationViewController(for: route, styles: [CustomStyle()])
        self.present(viewController, animated: true, completion: nil)
    }
    // #-end-code-snippet: navigation present-navigation-swift
    
    // #-code-snippet: navigation callout-tap-swift
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        self.presentNavigation(along: directionsRoute!)
    }
    // #-end-code-snippet: navigation callout-tap-swift
}
// #-end-code-snippet: navigation full-tutorial-swift

