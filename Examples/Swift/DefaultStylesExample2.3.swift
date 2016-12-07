//
//  DefaultStylesExample.swift
//  Examples
//
//  Created by Jason Wray on 1/28/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if !swift(>=3.0)
    
import Mapbox

@objc(DefaultStylesExample_Swift)

class DefaultStylesExample_Swift: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: MGLStyle.outdoorsStyleURLWithVersion(9))

        // Tint the ℹ️ button and the user location annotation.
        mapView.tintColor = .darkGrayColor()

        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 51.50713,
            longitude: -0.10957),
            zoomLevel: 13, animated: false)
        view.addSubview(mapView)
    }
}
#endif
