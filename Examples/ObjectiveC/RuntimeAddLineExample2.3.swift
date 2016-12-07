//
//  RuntimeAddLineExample.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(RuntimeAddLineExample_Swift)

class RuntimeAddLineExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
	super.viewDidLoad()

	mapView = MGLMapView(frame: view.bounds)
	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	mapView.setCenterCoordinate(
	    CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736),
	    zoomLevel: 11,
	    animated: false)
	view.addSubview(mapView)

	mapView.delegate = self
    }

    // Wait until the map is loaded before adding to the map
    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	loadGeoJson()
    }

    func loadGeoJson() {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
	    // Get the path for example.geojson in the app's bundle
	    guard let jsonPath = NSBundle.mainBundle().pathForResource("example", ofType: "geojson") else { return }
	    guard let jsonData = NSData(contentsOfFile: jsonPath) else { return }
	    dispatch_async(dispatch_get_main_queue(), {
		self.drawPolyline(jsonData)
	    })
	})
    }

    func drawPolyline(geoJson: NSData) {
	// Add our GeoJSON data to the map as a MGLGeoJSONSource
	// We can then reference this data from an MGLStyleLayer
	let source = MGLGeoJSONSource(identifier: "polyline", geoJSONData: geoJson, options: nil)
	self.mapView.style().addSource(source)

	// Create new layer for the line
	let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
	layer.lineJoin = MGLStyleValue(rawValue: NSValue(MGLLineJoin: .Round))
	layer.lineCap = MGLStyleValue(rawValue: NSValue(MGLLineCap: .Round))
	layer.lineColor = MGLStyleValue(rawValue: UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1))
	// Use a style function to smoothly adjust the line width from 2px to 20px between zoom levels 14 and 18. The `base` parameter allows the values to interpolate along an exponential curve
	layer.lineWidth = MGLStyleValue(base: 1.5, stops: [
	    14: MGLStyleValue(rawValue: 2),
	    18: MGLStyleValue(rawValue: 20),
	])

	// We can also add a second layer that will draw a stroke around the original line
	let casingLayer = MGLLineStyleLayer(identifier: "polyline-case", source: source)
	// Copy these attributes from the main line layer
	casingLayer.lineJoin = layer.lineJoin
	casingLayer.lineCap = layer.lineCap
	// Line gap width represents the space before the outline begins, so should match the main line's line width exactly
	casingLayer.lineGapWidth = layer.lineWidth
	// Stroke color slightly darker than the line color
	casingLayer.lineColor = MGLStyleValue(rawValue: UIColor(red: 41/255, green:145/255, blue:171/255, alpha:1))
	// Use a style function to gradually increase the stroke width between zoom 14 and 18
	casingLayer.lineWidth = MGLStyleValue(base: 1.5, stops: [
	    14: MGLStyleValue(rawValue: 1),
	    18: MGLStyleValue(rawValue: 4),
	])

	// Just for fun, let's add another copy of the line with a dash pattern
	let dashedLayer = MGLLineStyleLayer(identifier: "polyline-dash", source: source)
	dashedLayer.lineJoin = layer.lineJoin
	dashedLayer.lineCap = layer.lineCap
	dashedLayer.lineColor = MGLStyleValue(rawValue: UIColor.whiteColor())
	dashedLayer.lineOpacity = MGLStyleValue(rawValue: 0.5)
	dashedLayer.lineWidth = layer.lineWidth
	dashedLayer.lineDasharray = MGLStyleValue(rawValue: [0, 1.5])

	self.mapView.style().addLayer(layer)
	self.mapView.style().addLayer(dashedLayer)
	self.mapView.style().insertLayer(casingLayer, belowLayer: layer)
    }
}
#endif
