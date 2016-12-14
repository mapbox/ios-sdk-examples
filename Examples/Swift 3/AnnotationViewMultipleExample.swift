//
//  AnnotationViewMultipleExample.swift
//  Examples
//
//  Created by Nadia Barbosa on 12/13/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
    import Mapbox
    
    @objc(AnnotationViewMultipleExample_Swift)
    
    class AnnotationViewMultipleExample_Swift: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let mapView = MGLMapView(frame: view.bounds)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Set the map’s center coordinate and zoom level.
            mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
            view.addSubview(mapView)
        }
    }
#endif
