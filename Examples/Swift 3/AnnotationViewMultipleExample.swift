//
//  AnnotationViewMultipleExample.swift
//  Examples
//
//  Created by Nadia Barbosa on 12/13/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
    import Mapbox
    
    @objc(AnnotationViewMultipleExample_Swift)

    class AnnotationViewMultipleExample_Swift: UIViewController, MGLMapViewDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Create a new map view using the Mapbox Light style.
            let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: 39.83, longitude: -98.58), zoomLevel: 2, animated: false)
            
            view.addSubview(mapView)
            
            mapView.delegate = self
    
           // Create two new point annotations with specified coordinates and titles.
            let pointA = MGLPointAnnotation()
            pointA.coordinate = CLLocationCoordinate2D(latitude: 37.79, longitude: -122.43)
            pointA.title = "San Francisco"
            
            let pointB = MGLPointAnnotation()
            pointB.coordinate = CLLocationCoordinate2D(latitude: 38.90, longitude: -77.04)
            pointB.title = "Washington, D.C."
            
            let locations = [pointA, pointB]
            
            // Add all annotations to the map.
            mapView.addAnnotations(locations)
            
        }
        
        // This delegate method is where you tell the map to load a view for a specific annotation.
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            
            // This example is only concerned with point annotations.
            guard annotation is MGLPointAnnotation else {
                return nil
            }
            
            // Assign a reuse identifier to be used by the annotation views.
            let reuseIdentifier = "custom"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = MGLAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
                annotationView?.layer.borderWidth = 4.0
                annotationView?.layer.borderColor = UIColor.white.cgColor

                
                // Generate a random number between 0 and 1 to be used as the hue for the annotation view.
                let randomHue : CGFloat = CGFloat(arc4random_uniform(101)) / 100.0
                
                annotationView!.backgroundColor = UIColor(hue: randomHue, saturation: 1, brightness: 1, alpha: 1)
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always allow callouts to popup when annotations are tapped.
            return true
        }
        
    }
#endif
