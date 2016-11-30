//
//  RuntimeAddLineExample.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
import Mapbox

@objc(RuntimeAddLineExample_Swift)

class RuntimeAddLineExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
	super.viewDidLoad()

	mapView = MGLMapView(frame: view.bounds)
	mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

	mapView.setCenter(
	    CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736),
	    zoomLevel: 11,
	    animated: false)
	view.addSubview(mapView)

	mapView.delegate = self
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
	loadGeoJson()
    }

    func loadGeoJson() {
	DispatchQueue.global().async {
	    // Get the path for example.geojson in the app's bundle
	    guard let jsonUrl = Bundle.main.url(forResource: "example", withExtension: "geojson") else { return }
	    guard let jsonData = try? Data(contentsOf: jsonUrl) else { return }
	    DispatchQueue.main.async {
		self.drawPolyline(geoJson: jsonData)
	    }
	}
    }

    func drawPolyline(geoJson: Data) {
	let source = MGLGeoJSONSource(identifier: "polyline", geoJSONData: geoJson, options: nil)

	let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
	layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
	layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
	layer.lineColor = MGLStyleValue(rawValue: UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1))
	layer.lineWidth = MGLStyleValue(base: 1.5, stops: [
	    14: MGLStyleValue(rawValue: 2),
	    18: MGLStyleValue(rawValue: 20),
	    ])

	let casingLayer = MGLLineStyleLayer(identifier: "polyline-case", source: source)
	casingLayer.lineJoin = layer.lineJoin
	casingLayer.lineCap = layer.lineCap
	casingLayer.lineColor = MGLStyleValue(rawValue: UIColor(red: 41/255, green:145/255, blue:171/255, alpha:1))
	casingLayer.lineGapWidth = layer.lineWidth
	casingLayer.lineWidth = MGLStyleValue(base: 1.5, stops: [
	    14: MGLStyleValue(rawValue: 1),
	    18: MGLStyleValue(rawValue: 4),
	    ])

	self.mapView.style().add(source)
	self.mapView.style().add(layer)
	self.mapView.style().insert(casingLayer, below: layer)
    }
}
#endif
