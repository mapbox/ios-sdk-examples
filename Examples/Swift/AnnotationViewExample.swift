//
//  AnnotationViewExample.swift
//  Examples
//
//  Created by Jason Wray on 6/23/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(AnnotationViewExample_Swift)

class AnnotationViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURLWithVersion(9)
        mapView.tintColor = .darkGrayColor()
        mapView.zoomLevel = 1
        mapView.delegate = self
        view.addSubview(mapView)

        // Specify coordinates for our annotations.
        let coordinates = [
            CLLocationCoordinate2DMake(0, -70),
            CLLocationCoordinate2DMake(0, -35),
            CLLocationCoordinate2DMake(0,  0),
            CLLocationCoordinate2DMake(0, 35),
            CLLocationCoordinate2DMake(0, 70),
        ]

        // Fill an array with point annotations and add it to the map.
        var pointAnnotations = [MGLPointAnnotation]()
        for coordinate in coordinates {
            let point = MGLPointAnnotation()
            point.coordinate = coordinate
            point.title = "To drag this annotation, first tap and hold."
            pointAnnotations.append(point)
        }

        mapView.addAnnotations(pointAnnotations)
    }

    // MARK: - MGLMapViewDelegate methods

    // This delegate method is where you tell the map to load a view for a specific annotation. To load a GL-based MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        // For better performance, always try to reuse existing annotations. To use multiple different annotation views, change the reuse identifier for each.
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("draggablePoint") {
            return annotationView
        } else {
            return CustomDraggableAnnotationView(reuseIdentifier: "draggablePoint", size: 50)
        }
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
