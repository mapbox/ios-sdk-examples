//
//  DDSLayerSelectionExample.swift
//  Examples
//
//  Created by Jordan Kiley on 3/21/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

@objc(DDSLayerSelectionExample_Swift)

class DDSLayerSelectionExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
}
