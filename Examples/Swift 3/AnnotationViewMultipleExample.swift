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
            
            let mapView = MGLMapView(frame: view.bounds)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: 39.83, longitude: -98.58), zoomLevel: 2, animated: false)
            
            view.addSubview(mapView)
            
            mapView.delegate = self
    
            
            struct annotationCollection {
                let location: CLLocationCoordinate2D
                let title: String
                
            }
            
            var myStruct1 = annotationCollection(location: CLLocationCoordinate2D(latitude: 37.79, longitude: -122.43), title: "Point A")
            
            var myStruct2 = annotationCollection(location: CLLocationCoordinate2D(latitude: 38.90, longitude: -77.04), title: "Point B")
            
            let myArray = [myStruct1, myStruct2]
            
            var pointAnnotations = [MGLPointAnnotation]()
            
            for item in myArray {
                let point = MGLPointAnnotation()
                point.coordinate = item.location
                point.title = item.title
                pointAnnotations.append(point)
            }
            
            mapView.addAnnotations(pointAnnotations)
            
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
    }
#endif
