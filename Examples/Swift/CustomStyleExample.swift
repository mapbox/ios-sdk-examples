//
//  CustomStyleExample.swift
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(CustomStyleExample_Swift)

class CustomStyleExample_Swift: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // fill in the next line with your style URL from Mapbox Studio
        // <#mapbox://styles/userName/styleHash#>
        let styleURL = NSURL(string: "mapbox://styles/mapbox/outdoors-v9")
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: styleURL)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        // set the map's center coordinate
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.52954,
            longitude: -122.72317),
            zoomLevel: 14, animated: false)
        view.addSubview(mapView)
    }
}
