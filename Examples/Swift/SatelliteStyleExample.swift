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

        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)

        view.addSubview(mapView)
    }
}
