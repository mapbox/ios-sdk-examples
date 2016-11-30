//
//  RuntimeCircleStylesExample2.3.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(RuntimeCircleStylesExample_Swift)

class RuntimeCircleStylesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
	super.viewDidLoad()

	mapView = MGLMapView(frame: view.bounds)
	mapView.styleURL = MGLStyle.lightStyleURLWithVersion(9)
	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	mapView.setCenterCoordinate(
	    CLLocationCoordinate2D(latitude: 37.753574, longitude: -122.447303),
	    zoomLevel: 10,
	    animated: false)
	view.addSubview(mapView)

	mapView.delegate = self
    }

    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	addLayer()
    }

    func addLayer() {
	let source = MGLVectorSource(identifier: "population", URL: NSURL(string: "mapbox://examples.8fgz4egr")!)

	let ethnicities = [
	    "White": UIColor(red: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1.0),
	    "Black": UIColor(red: 34/255.0, green: 59/255.0, blue: 83/255.0, alpha: 1.0),
	    "Hispanic": UIColor(red: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1.0),
	    "Asian": UIColor(red: 59/255.0, green: 178/255.0, blue: 208/255.0, alpha: 1.0),
	    "Other": UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0),
	]

	self.mapView.style().addSource(source)
	for (ethnicity, color) in ethnicities {
	    let layer = MGLCircleStyleLayer(identifier: "population-\(ethnicity)", source: source)
	    layer.sourceLayerIdentifier = "sf2010"
	    layer.circleRadius = MGLStyleValue(base: 1.75, stops: [
		12: MGLStyleValue(rawValue: 2),
		22: MGLStyleValue(rawValue: 180)
	    ])
	    layer.circleOpacity = MGLStyleValue(rawValue: 0.7)
	    layer.circleColor = MGLStyleValue(rawValue: color)
	    layer.predicate = NSPredicate(format: "%K == %@", "ethnicity", ethnicity)
	    self.mapView.style().addLayer(layer)
	}
    }
}
#endif
