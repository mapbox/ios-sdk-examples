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
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            
            guard annotation is MGLPointAnnotation else {
                return nil
            }
            
        
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                let hue : CGFloat = CGFloat(arc4random() % 256) / 256
                
                annotationView!.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
    }
#endif
