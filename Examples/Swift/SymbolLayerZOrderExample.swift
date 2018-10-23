//
//  SymbolLayerZOrderExample.swift
//  Examples
//
//  Created by Sam Fader on 10/15/18.
//  Copyright © 2018 Mapbox. All rights reserved.
//

import Foundation
import Mapbox

@objc(SymbolLayerZOrderExample_Swift)

class SymbolLayerZOrderExample_Swift: UIViewController, MGLMapViewDelegate {

var mapView: MGLMapView!

override func viewDidLoad() {
    super.viewDidLoad()
    // Create a new map view using the Mapbox Light style.
    mapView = MGLMapView(frame: view.bounds)
    mapView.styleURL = MGLStyle.lightStyleURL
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.tintColor = .darkGray
    // Set the map’s center coordinate and zoom level.
    mapView.setCenter(CLLocationCoordinate2D(latitude: -41.292650, longitude: 174.778768), animated: false)
    mapView.zoomLevel = 11.5
    mapView.delegate = self
    view.addSubview(mapView)
}

// Wait until the style is loaded before modifying the map style.
func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Add icons to the map's style.
        style.setImage(UIImage(named: "oval")!, forName: "oval")
        style.setImage(UIImage(named: "squircle")!, forName: "squircle")
        style.setImage(UIImage(named: "star")!, forName: "star")
    
        let feature1 = MGLPointFeature()
        feature1.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
        feature1.attributes = ["id": "squircle"]
        let feature2 = MGLPointFeature()
        feature2.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
        feature2.attributes = ["id": "oval"]
        let feature3 = MGLPointFeature()
        feature3.coordinate = CLLocationCoordinate2DMake(-41.292650, 174.778768)
        feature3.attributes = ["id": "star"]
    
        let shapeCollection = MGLShapeCollectionFeature(shapes: [feature1, feature2, feature3])
        let source = MGLShapeSource(identifier: "symbol-layer-z-order-example", shape: shapeCollection, options: nil)
        style.addSource(source)
        let layer = MGLSymbolStyleLayer(identifier: "points-style", source: source)
        layer.sourceLayerIdentifier = "symbol-layer-z-order-example"
    
        // Create a stops dictionary with keys that are possible values for 'id', paired with icon images that will represent those features.
        let icons = ["squircle": "squircle", "oval": "oval", "star": "star"]
        // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
        layer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', id)", icons)
    
        layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        layer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        layer.symbolZOrder = NSExpression(forConstantValue: "source")
        style.addLayer(layer)
    }
}
