//
//  SatelliteStyleExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if swift(>=3.0)
    
import Mapbox

@objc(SatelliteStyleExample_Swift)

class SatelliteStyleExample_Swift: UIViewController {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A hybrid style with unobtrusive labels is also available via satelliteStreetsStyleURLWithVersion().
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStyleURL(withVersion: 9))
        
        // Tint the ℹ️ button.
        mapView.attributionButton.tintColor = UIColor.white
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)
        
        view.addSubview(mapView)
    }
    
}
#endif
