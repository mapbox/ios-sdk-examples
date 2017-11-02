//
//  LiveDataExample.swift
//  Examples
//
//  Created by Jordan Kiley on 6/7/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

// TODO: JK - timer reference https://github.com/IBM-Swift/Kitura-Cache/blob/master/Sources/KituraCache/KituraCache.swift#L211 https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlDispatch.swift
import Mapbox

@objc(LiveDataExample_Swift)

class LiveDataExample: UIViewController, MGLMapViewDelegate {
    
    var source : MGLShapeSource!
    let timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        mapView.tintColor = .gray
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
    {
        
        if let url = URL(string: "https://wanderdrone.appspot.com/") {
            source = MGLShapeSource(identifier: "drone-source", url: url, options: nil)
            style.addSource(source)
            
            let droneLayer = MGLSymbolStyleLayer(identifier: "drone-layer", source: source)
            droneLayer.iconImageName = MGLStyleValue(rawValue: "rocket-15")
            droneLayer.iconHaloColor = MGLStyleValue(rawValue: .white)
            style.addLayer(droneLayer)
            
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateUrl), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func updateUrl() {
        if let url = URL(string: "https://wanderdrone.appspot.com/") {
            source.url = url
        }
        print("hi")
    }
    deinit {
        
    }
}
