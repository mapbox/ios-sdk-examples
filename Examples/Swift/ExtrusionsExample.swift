//
//  ExtrusionsExample.swift
//  Examples
//
//  Created by Jordan Kiley on 5/10/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

@objc(ExtrusionsExample_Swift)

class ExtrusionsExample: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
        mapView.setCenter(CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922), animated: false)

        // Set the `MGLMapCamera` to one
        mapView.camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 600, pitch: 60, heading: 0)

        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Access the Mapbox Streets source.
        let source = style.source(withIdentifier: "composite")
        
        // Create a `MGLFillExtrusionLayer` using the building layer from that source.
        let layer = MGLFillExtrusionStyleLayer(identifier: "buildings", source: source!)
        layer.sourceLayerIdentifier = "building"
        
        // Check that the building is should
        layer.predicate = NSPredicate(format: "extrude != false AND height >=0")
        
        layer.fillExtrusionHeight = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "height", options: nil)
        
        layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.75)
        layer.fillExtrusionColor = MGLStyleValue(rawValue: .white)
        let symbolLayer = style.layer(withIdentifier: "poi-scalerank3")
        style.insertLayer(layer, below: symbolLayer!)
        
    }
    
}
