
//
//  CalloutDelegateUsageExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)

import Mapbox

@objc(CalloutDelegateUsageExample_Swift)

class CalloutDelegateUsageExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        // Remember to set the delegate.
        mapView.delegate = self
        
        addAnnotation()
    }
    
    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 35.03946, longitude: 135.72956)
        annotation.title = "Kinkaku-ji"
        annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        
        mapView.addAnnotation(annotation)
        
        // Center the map on the annotation.
        mapView.setCenter(annotation.coordinate, zoomLevel: 17, animated: false)
        
        // Pop-up the callout view.
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! == "Kinkaku-ji") {
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "金閣寺"
            
            return label
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        UIAlertView(title: annotation.title!!, message: "A lovely (if touristy) place.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()
    }
}
#endif
