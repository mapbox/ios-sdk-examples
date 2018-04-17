import UIKit
import Mapbox

class FirstStepsTutorialViewController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // #-code-snippet: first-steps-ios-sdk initialize-map-swift
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        // #-end-code-snippet: first-steps-ios-sdk initialize-map-swift
        
        // #-code-snippet: first-steps-ios-sdk change-style-swift
        mapView.styleURL = MGLStyle.satelliteStyleURL
        // #-end-code-snippet: first-steps-ios-sdk change-style-swift
        
        // #-code-snippet: first-steps-ios-sdk add-annotation-swift
        // Add a point annotation
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.77014, longitude: -73.97480)
        annotation.title = "Central Park"
        annotation.subtitle = "The biggest park in New York City!"
        mapView.addAnnotation(annotation)
        // #-end-code-snippet: first-steps-ios-sdk add-annotation-swift
        
        // #-code-snippet: first-steps-ios-sdk set-delegate-swift
        // Set the map view's delegate
        mapView.delegate = self
        // #-end-code-snippet: first-steps-ios-sdk set-delegate-swift
        
        // #-code-snippet: first-steps-ios-sdk show-location-swift
        // Allow the map view to display the user's location
        mapView.showsUserLocation = true
        // #-end-code-snippet: first-steps-ios-sdk show-location-swift
    }
    
    // #-code-snippet: first-steps-ios-sdk can-show-callout-swift
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
    // #-end-code-snippet: first-steps-ios-sdk can-show-callout-swift
    
    // #-code-snippet: first-steps-ios-sdk fly-to-annotation-swift
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
                    peakAltitude: 3000, completionHandler: nil)
    }
    // #-end-code-snippet: first-steps-ios-sdk fly-to-annotation-swift
}
