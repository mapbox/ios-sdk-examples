//
//  RuntimeCircleStylesExample.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
import Mapbox

@objc(RuntimeCircleStylesExample_Swift)

class RuntimeCircleStylesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL(withVersion: 9)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 37.753574, longitude: -122.447303),
            zoomLevel: 10,
            animated: false)
        view.addSubview(mapView)
        
        mapView.delegate = self
    }

    // Wait until the style is loaded before modifying the map style
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
	addLayer()
    }

    func addLayer() {
	let source = MGLVectorSource(identifier: "population", configurationURL: URL(string: "mapbox://examples.8fgz4egr")!)

	let ethnicities = [
	    "White": UIColor(red: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1.0),
	    "Black": UIColor(red: 34/255.0, green: 59/255.0, blue: 83/255.0, alpha: 1.0),
	    "Hispanic": UIColor(red: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1.0),
	    "Asian": UIColor(red: 59/255.0, green: 178/255.0, blue: 208/255.0, alpha: 1.0),
	    "Other": UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0),
	    ]

	self.mapView.style.addSource(source)

	// Create a new layer for each ethnicity/circle color
	for (ethnicity, color) in ethnicities {
	    // Each layer should have a unique identifier
	    let layer = MGLCircleStyleLayer(identifier: "population-\(ethnicity)", source: source)

	    // Specifying the sourceLayerIdentifier is required for a vector tile source. This is the json attribute that wraps the data in the source
	    layer.sourceLayerIdentifier = "sf2010"

	    // Use a style function to smoothly adjust the circle radius from 2px to 180px between zoom levels 12 and 22. The `base` parameter allows the values to interpolate along an exponential curve
	    layer.circleRadius = MGLStyleValue(base: 1.75, stops: [
		12: MGLStyleValue(rawValue: 2),
		22: MGLStyleValue(rawValue: 180)
		])
	    layer.circleOpacity = MGLStyleValue(rawValue: 0.7)

	    // Set the circle color to match the ethnicity
	    layer.circleColor = MGLStyleValue(rawValue: color)

	    // Use an NSPredicate to filter to just one ethnicity for this layer
	    layer.predicate = NSPredicate(format: "%K == %@", "ethnicity", ethnicity)

	    self.mapView.style.addLayer(layer)
	}
    }
}
#endif
