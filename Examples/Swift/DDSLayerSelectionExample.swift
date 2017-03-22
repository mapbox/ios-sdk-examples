//
//  DDSLayerSelectionExample.swift
//  Examples
//
//  Created by Jordan Kiley on 3/21/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

@objc(DDSLayerSelectionExample_Swift)

class DDSLayerSelectionExample_Swift: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var mapView : MGLMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(mapView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gesture.delegate = self
        mapView.addGestureRecognizer(gesture)
    }
    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        let spot = gesture.location(in: mapView)
        let features = mapView.visibleFeatures(at: spot, styleLayerIdentifiers: Set(["state-layer"]))
        
        if let feature = features.first, let state = feature.attribute(forKey: "name") as? String{
            changeOpacity(name: state)
        } else {
            changeOpacity(name: "")
        }
    }
    
    func changeOpacity(name: String) {
        let layer = mapView.style?.layer(withIdentifier: "state-layer") as! MGLFillStyleLayer
        if name.characters.count > 0 {
            layer.fillOpacity = MGLStyleValue(interpolationMode: .categorical, sourceStops: [name : MGLStyleValue<NSNumber>(rawValue: 1)], attributeName: "name", options: [.defaultValue : MGLStyleValue<NSNumber>(rawValue: 0)])
            
        } else {
            layer.fillOpacity = MGLStyleValue(rawValue: 1)
        }
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        let url = URL(string: "mapbox://examples.69ytlgls")!
        let source = MGLVectorSource(identifier: "state-source", configurationURL: url)
        style.addSource(source)
        
        let layer = MGLFillStyleLayer(identifier: "state-layer", source: source)
        layer.sourceLayerIdentifier = "stateData_2-dx853g"
        let stops = [
            0: MGLStyleValue(rawValue: UIColor(red:0.94, green:0.93, blue:0.96, alpha:1.0)),
            600: MGLStyleValue(rawValue: UIColor(red:0.62, green:0.60, blue:0.78, alpha:1.0)),
            1200: MGLStyleValue(rawValue: UIColor(red:0.33, green:0.15, blue:0.56, alpha:1.0))]
        
        layer.fillColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "density", options: [.defaultValue : MGLStyleValue(rawValue: .white)])
        let symbolLayer = style.layer(withIdentifier: "place-city-sm")
        style.insertLayer(layer, below: symbolLayer!)
    }
}
