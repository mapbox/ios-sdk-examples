//
//  LiveDataExample.swift
//  Examples
//
//  Created by Jordan Kiley on 6/7/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

@objc(LiveDataExample_Swift)

class LiveDataExample: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds,
                             styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        
        mapView.delegate = self
        
        mapView.tintColor = .gray
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
    {
        if var url = URL(string: "https://wanderdrone.appspot.com/") {
            let source = MGLShapeSource(identifier: "drone", url: url, options: nil)
            style.addSource(source)
            
            let droneLayer = MGLSymbolStyleLayer(identifier: "drone", source: source)
            droneLayer.iconImageName = MGLStyleValue(rawValue: "rocket-15")
            droneLayer.iconColor = MGLStyleValue(rawValue: .white)
            droneLayer.iconPadding = MGLStyleValue(rawValue: 5)
            style.addLayer(droneLayer)
            
            
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (time) in
                    source.url = url
                    
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
