//
//  CustomRasterExample.swift
//  Examples
//
//  Created by Jason Wray on 1/29/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//
#if swift(>=3.0)
    
import Mapbox

@objc(CustomRasterStyleExample_Swift)

class CustomRasterStyleExample_Swift: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let styleURL = NSURL(string: "https://www.mapbox.com/ios-sdk/files/mapbox-raster-v8.json")
        // Local paths are also acceptable.
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: styleURL as URL?)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
    }
}
#endif
