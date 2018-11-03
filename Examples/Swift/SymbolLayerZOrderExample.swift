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
var symbolLayer: MGLSymbolStyleLayer?

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
        layer.symbolZOrder = NSExpression(forConstantValue: "source")
        style.addLayer(layer)
    
        self.symbolLayer = layer
    
        // Create a UISegmentedControl to toggle between map styles
        let styleToggle = UISegmentedControl(items: ["viewport-y", "source"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
        styleToggle.backgroundColor = UIColor(red: 0.973, green: 0.329, blue: 0.294, alpha: 1)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
        styleToggle.selectedSegmentIndex = 1
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(toggleLayer(sender:)), for: .valueChanged)
    
        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mapView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }
    // Change the map style based on the selected index of the UISegmentedControl
    @objc func toggleLayer(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            useSource()
        case 1:
            useViewportY()
        default:
            useSource()
        }
    }
    
    func useSource() {
        self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "source")
    }
    
    func useViewportY() {
        self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "viewport-y")
    }
}
