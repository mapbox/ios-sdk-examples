//
//  MapSnapshotterExample.swift
//  Examples
//
//  Created by Jordan Kiley on 11/3/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

@objc(MapSnapshotterExample_Swift)

class MapSnapshotterExample: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        // Center map on Istanbul, Turkey.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784), zoomLevel: 10, animated: false)
        view.addSubview(mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let camera = mapView.camera
        print(camera.pitch)
        
        let options = MGLMapSnapshotOptions(styleURL: mapView.styleURL, camera: mapView.camera, size: CGSize(width: 320, height: 480))
        let snapshotter = MGLMapSnapshotter(options: options)
        
        snapshotter.start { (image, error) in
            if error != nil {
                print("Unable to create a map snapshot.")
            } else {
                
            }
        }
        
    }
    
}
