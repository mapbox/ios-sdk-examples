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
        mapView.styleURL = MGLStyle.satelliteStreetsStyleURLWithVersion(9)
        mapView.tintColor = .whiteColor()
        mapView.zoomLevel = 1
        mapView.delegate = self
        view.addSubview(mapView)

        // Point Annotation
        let point = CustomPointAnnotation(coordinate: CLLocationCoordinate2DMake(0, 0),
                                          title: "Custom Point Annotation",
                                          subtitle: nil)
        // Set the custom `image` and `reuseIdentifier` properties, later used in the `mapView:imageForAnnotation:` delegate method.
        point.reuseIdentifier = "yeOldeGreyDot"
        //point.image = dotWithSize(20)

        // Polyline
        // Create a coordinates array with all of the coordinates for our polyline.
        var coordinates = [
            CLLocationCoordinate2DMake(35, -25),
            CLLocationCoordinate2DMake(20, -30),
            CLLocationCoordinate2DMake( 0, -25),
            CLLocationCoordinate2DMake(-15,  0),
            CLLocationCoordinate2DMake(-45, 10),
            CLLocationCoordinate2DMake(-45, 40),
            ]

        let polyline = CustomPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        // Set the custom `color` property, later used in the `mapView:strokeColorForShapeAnnotation:` delegate method.
        polyline.color = .darkGrayColor()

        // Add both annotations to the map.
        mapView.addAnnotations([point, polyline])
    }

}
