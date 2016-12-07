//
//  CameraAnimationExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if !swift(>=3.0)

import Mapbox

@objc(CameraAnimationExample_Swift)

class CameraAnimationExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.delegate = self

        mapView.styleURL = MGLStyle.outdoorsStyleURLWithVersion(9);

        // Mauna Kea, Hawaii
        let center = CLLocationCoordinate2D(latitude: 19.820689, longitude: -155.468038)

        // Optionally set a starting point.
        mapView.setCenterCoordinate(center, zoomLevel: 7, direction: 0, animated: false)

        view.addSubview(mapView)
    }

    func mapViewDidFinishLoadingMap(mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.

        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 4500, pitch: 15, heading: 180)

        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
}
#endif
