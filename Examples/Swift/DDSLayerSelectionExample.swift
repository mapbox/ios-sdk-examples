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
    var isStateSelected : Bool = false
    
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
            changeOpacity(name: state, finished: {
                isStateSelected = !isStateSelected
            })
        }
    }
    
    func changeOpacity(name: String, finished: ()->()) {
        
        let layer = mapView.style?.layer(withIdentifier: "state-layer") as! MGLFillStyleLayer
        if !isStateSelected  && name.characters.count > 0 {
                layer.fillOpacity = MGLStyleValue(interpolationMode: .categorical, sourceStops: [name : MGLStyleValue<NSNumber>(rawValue: 1)], attributeName: "name", options: [.defaultValue : MGLStyleValue<NSNumber>(rawValue: 0)])
        
        } else {
            layer.fillOpacity = MGLStyleValue(rawValue: 1)
        }
        finished()
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        let url = URL(string: "mapbox://examples.69ytlgls")!
        let source = MGLVectorSource(identifier: "state-source", configurationURL: url)
        style.addSource(source)
        
        let layer = MGLFillStyleLayer(identifier: "state-layer", source: source)
        layer.sourceLayerIdentifier = "stateData_2-dx853g"
        let stops = [0: MGLStyleValue<UIColor>(rawValue: .yellow),
                     100: MGLStyleValue<UIColor>(rawValue: .red),
                     1200: MGLStyleValue<UIColor>(rawValue: .blue)]
        
        layer.fillColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "density", options: [.defaultValue : MGLStyleValue<UIColor>(rawValue: .white)])
        let symbolLayer = style.layer(withIdentifier: "state-label-sm")
        style.insertLayer(layer, below: symbolLayer!)
    }
}
