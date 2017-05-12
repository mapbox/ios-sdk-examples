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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
        
        // Center the map on the Colosseum in Rome, Italy.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922), animated: false)
        
        // Set the map view camera's pitch and distance.
        mapView.camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 600, pitch: 60, heading: 0)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        if let source = style.source(withIdentifier: "composite") {
            let layer = MGLFillExtrusionStyleLayer(identifier: "buildings", source: source)
            layer.sourceLayerIdentifier = "building"
            
            // Filter out buildings that should not extrude.
            layer.predicate = NSPredicate(format: "extrude != false AND height >=0")
            
            // Set the fill extrusion height to the value for the building height attribute.
            layer.fillExtrusionHeight = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "height", options: nil)
            layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.75)
            layer.fillExtrusionColor = MGLStyleValue(rawValue: .white)
            
            // Insert the fill extrusion layer below a POI label layer. Use the `layers` property on a style to verify built-in layer identifiers.
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
}
