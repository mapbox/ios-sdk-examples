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
    
    // Example view controller
    class AnnotationViewMultipleExample_Swift: UIViewController, MGLMapViewDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: 39.83, longitude: -98.58), zoomLevel: 2, animated: false)
            
            view.addSubview(mapView)
            
            mapView.delegate = self
    
            struct annotationCollection {
                let location: CLLocationCoordinate2D
                let title: String
            }
            
            let pointA = annotationCollection(location: CLLocationCoordinate2D(latitude: 37.79, longitude: -122.43), title: "San Francisco")
            
            let pointB = annotationCollection(location: CLLocationCoordinate2D(latitude: 38.90, longitude: -77.04), title: "Washington, D.C")
            
            let locations = [pointA, pointB]
            
            // Fill an array with point annotations and add it to the map.
            var pointAnnotations = [MGLPointAnnotation]()
            for item in locations {
                let point = MGLPointAnnotation()
                point.coordinate = item.location
                point.title = item.title
                pointAnnotations.append(point)
            }
            
            // Add all annotation to the map.
            mapView.addAnnotations(pointAnnotations)
            
        }
        
        // This delegate method is where you tell the map to load a view for a specific annotation.
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            
            // This example is only concerned with point annotations.
            guard annotation is MGLPointAnnotation else {
                return nil
            }
            
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                // Generate a random number between 0 and 1
                let randomHue : CGFloat = CGFloat(arc4random_uniform(101)) / 100.0
                
                annotationView!.backgroundColor = UIColor(hue: randomHue, saturation: 1, brightness: 1, alpha: 1)
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            // Always allow callouts to popup when annotations are tapped
            return true
        }
        
    }
#endif
