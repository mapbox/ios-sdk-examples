//
//  SatelliteStyleExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(SatelliteStyleExample_Swift)

class SatelliteStyleExample_Swift: UIViewController {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // A Hybrid style with unobtrusive labels is also available via hybridStyleURL().
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStyleURL())

        // Tint the ℹ️ button.
        mapView.attributionButton.tintColor = .whiteColor()

        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        // Set the map's center coordinates and zoom level
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)

        view.addSubview(mapView)
    }
}
