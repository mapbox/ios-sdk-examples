//
//  SourceCustomVectorExample2.3.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(SourceCustomVectorExample_Swift)

class SourceCustomVectorExample_Swift: UIViewController {

    var mapView: MGLMapView!

    override func viewDidLoad() {
	super.viewDidLoad()


	mapView = MGLMapView(frame: view.bounds, styleURL: NSBundle.mainBundle().URLForResource("third_party_vector_style", withExtension: "json")!)

	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	view.addSubview(mapView)
    }
}
#endif
