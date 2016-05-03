//
//  ReplacingAMarkerImageExample.swift
//  Examples
//
//  Created by Jason Wray on 2/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(ReplacingAMarkerImageExample_Swift)

class ReplacingAMarkerImageExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        view.addSubview(mapView)

        // Set the map view‘s delegate property
        mapView.delegate = self

        addAnnotation()
    }

    func addAnnotation() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(0, 0)
        annotation.title = "MegaCorp Annotation"

        mapView.addAnnotation(annotation)
    }

    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation)
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier)

        if annotationImage == nil {
            let image = UIImage(named: "apple")!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }

        return annotationImage
    }

    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation)

        if let annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(reuseIdentifier) {

            if annotationImage.image == UIImage(named: "apple")! {
                annotationImage.image = UIImage(named: "google")!
            } else {
                annotationImage.image = UIImage(named: "apple")!
            }
        }

        mapView.deselectAnnotation(annotation, animated: false)
    }

    func reuseIdentifierForAnnotation(annotation: MGLAnnotation) -> String {
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title where title != nil {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle where subtitle != nil {
            reuseIdentifier += subtitle!
        }
        return reuseIdentifier
    }
    
}
