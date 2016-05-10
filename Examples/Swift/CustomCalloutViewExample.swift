//
//  CustomCalloutViewExample.swift
//  Examples
//
//  Created by Jason Wray on 3/11/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(CustomCalloutViewExample_Swift)

class CustomCalloutViewExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURLWithVersion(9))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.tintColor = UIColor.darkGrayColor()
        view.addSubview(mapView)

        // Set the map view‘s delegate property
        mapView.delegate = self

        // Initialize and add the marker annotation
        let marker = MGLPointAnnotation()
        marker.coordinate = CLLocationCoordinate2DMake(0, 0)
        marker.title = "Hello world!"

        // This custom callout example does not implement subtitles
        //marker.subtitle = "Welcome to my marker"

        // Add marker to the map
        mapView.addAnnotation(marker)
    }

    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }

    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
        if annotation.respondsToSelector(Selector("title")) && annotation.title! == "Hello world!" {
            // Instantiate and return our custom callout view
            return CustomCalloutView(representedObject: annotation)
        }
        return nil
    }

    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")

        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }
}
