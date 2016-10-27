//
//  AnnotationViewExample.swift
//  Examples
//
//  Created by Jason Wray on 6/23/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)

import Mapbox

@objc(AnnotationViewExample_Swift)
// Example view controller

class AnnotationViewExample_Swift: UIViewController, MGLMapViewDelegate {
    
    // #if !swift(>=3.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.styleURL = MGLStyle.darkStyleURLWithVersion(9)
        mapView.tintColor = .lightGrayColor()
        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 66)
        mapView.zoomLevel = 2
        mapView.delegate = self
        view.addSubview(mapView)
        
        // Specify coordinates for our annotations.
        let coordinates = [
            CLLocationCoordinate2DMake(0, 33),
            CLLocationCoordinate2DMake(0, 66),
            CLLocationCoordinate2DMake(0, 99),
            ]
        
        // Fill an array with point annotations and add it to the map.
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "\(coordinate.latitude), \(coordinate.longitude)"
            pointAnnotations.append(point)
        }
        
        mapView.addAnnotations(pointAnnotations)
    }
    
    // MARK: - MGLMapViewDelegate methods
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRectMake(0, 0, 40, 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    /*
    #else
    override func viewDidLoad() {
    super.viewDidLoad()
    
    let mapView = MGLMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.styleURL = MGLStyle.darkStyleURL(withVersion: 9)
    mapView.tintColor = .lightGray
    mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 66)
    mapView.zoomLevel = 2
    mapView.delegate = self
    view.addSubview(mapView)
    
    // Specify coordinates for our annotations.
    let coordinates = [
    CLLocationCoordinate2DMake(0, 33),
    CLLocationCoordinate2DMake(0, 66),
    CLLocationCoordinate2DMake(0, 99),
    ]
    
    // Fill an array with point annotations and add it to the map.
    var pointAnnotations = [MGLPointAnnotation]()
    for coordinate in coordinates {
    let point = MGLPointAnnotation()
    point.coordinate = coordinate
    point.title = "\(coordinate.latitude), \(coordinate.longitude)"
    pointAnnotations.append(point)
    }
    
    mapView.addAnnotations(pointAnnotations)
    }
    
    // MARK: - MGLMapViewDelegate methods
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
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
    annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    
    // Set the annotation view’s background color to a value determined by its longitude.
    let hue = CGFloat(annotation.coordinate.longitude) / 100
    annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
    }
    
    return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    return true
    }
    
    #endif
 */
}

//
// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    // #if !swift(>=3.0)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.addAnimation(animation, forKey: "borderWidth")
    }
    
   /*
 #else
    
    override func layoutSubviews() {
    super.layoutSubviews()
    
    // Force the annotation view to maintain a constant size when the map is tilted.
    scalesWithViewingDistance = false
    
    // Use CALayer’s corner radius to turn this view into a circle.
    layer.cornerRadius = frame.width / 2
    layer.borderWidth = 2
    layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Animate the border width in/out, creating an iris effect.
    let animation = CABasicAnimation(keyPath: "borderWidth")
    animation.duration = 0.1
    layer.borderWidth = selected ? frame.width / 4 : 2
    layer.add(animation, forKey: "borderWidth")
    }
    
    #endif
 */
}
#endif