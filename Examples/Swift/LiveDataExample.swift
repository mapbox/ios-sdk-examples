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
            let source = MGLShapeSource(identifier: "drone-source", url: url, options: nil)
            style.addSource(source)
            
            let droneLayer = MGLSymbolStyleLayer(identifier: "drone-layer", source: source)
            droneLayer.iconImageName = MGLStyleValue(rawValue: "rocket-15")
            droneLayer.iconHaloColor = MGLStyleValue(rawValue: .white)
            style.addLayer(droneLayer)
            
            
            // TODO: Use a DispatchSourceTimer to reset the source url.
            let queue = DispatchQueue(label: "update-drone-timer", attributes: .concurrent, target: .main)
            
            let timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
//            timer.schedule(deadline: .now(), repeating: 1, leeway: .now)
            timer.schedule(deadline: .now() + 1, repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
            timer.setEventHandler { [weak self] in
                source.url = url
            }
            
            timer.resume()
//            if #available(iOS 10.0, *) {
//                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (time) in
//
//
//                })
//            } else {
//                // Fallback on earlier versions
//            }
        }
    }
    
    deinit {
        
    }
}
