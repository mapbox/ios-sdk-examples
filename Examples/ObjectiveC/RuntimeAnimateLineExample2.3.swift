//
//  RuntimeAnimateLineExample.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(RuntimeAnimateLineExample_Swift)

class RuntimeAnimateLineExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    var timer: NSTimer?

    var polylineSource: MGLGeoJSONSource?

    var currentIndex = 0

    var allCoordinates: [CLLocationCoordinate2D] = [
	[-122.63748, 45.52214],
	[-122.64855, 45.52218],
	[-122.6545, 45.52219],
	[-122.65497, 45.52196],
	[-122.65631, 45.52104],
	[-122.6578, 45.51935],
	[-122.65867, 45.51848],
	[-122.65872, 45.51293],
	[-122.66576, 45.51295],
	[-122.66745, 45.51252],
	[-122.66813, 45.51244],
	[-122.67359, 45.51385],
	[-122.67415, 45.51406],
	[-122.67481, 45.51484],
	[-122.676, 45.51532],
	[-122.68106, 45.51668],
	[-122.68503, 45.50934],
	[-122.68546, 45.50858],
	[-122.6852, 45.50783],
	[-122.68424, 45.50714],
	[-122.68433, 45.50585],
	[-122.68429, 45.50521],
	[-122.68456, 45.50445],
	[-122.68538, 45.50371],
	[-122.68653, 45.50311],
	[-122.68731, 45.50292],
	[-122.68742, 45.50253],
	[-122.6867, 45.50239],
	[-122.68545, 45.5026],
	[-122.68407, 45.50294],
	[-122.68357, 45.50271],
	[-122.68236, 45.50055],
	[-122.68233, 45.49994],
	[-122.68267, 45.49955],
	[-122.68257, 45.49919],
	[-122.68376, 45.49842],
	[-122.68428, 45.49821],
	[-122.68573, 45.49798],
	[-122.68923, 45.49805],
	[-122.68926, 45.49857],
	[-122.68814, 45.49911],
	[-122.68865, 45.49921],
	[-122.6897, 45.49905],
	[-122.69346, 45.49917],
	[-122.69404, 45.49902],
	[-122.69438, 45.49796],
	[-122.69504, 45.49697],
	[-122.69624, 45.49661],
	[-122.69781, 45.4955],
	[-122.69803, 45.49517],
	[-122.69711, 45.49508],
	[-122.69688, 45.4948],
	[-122.69744, 45.49368],
	[-122.69702, 45.49311],
	[-122.69665, 45.49294],
	[-122.69788, 45.49212],
	[-122.69771, 45.49264],
	[-122.69835, 45.49332],
	[-122.7007, 45.49334],
	[-122.70167, 45.49358],
	[-122.70215, 45.49401],
	[-122.70229, 45.49439],
	[-122.70185, 45.49566],
	[-122.70215, 45.49635],
	[-122.70346, 45.49674],
	[-122.70517, 45.49758],
	[-122.70614, 45.49736],
	[-122.70663, 45.49736],
	[-122.70807, 45.49767],
	[-122.70807, 45.49798],
	[-122.70717, 45.49798],
	[-122.70713, 45.4984],
	[-122.70774, 45.49893]
    ].map({CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])})

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

    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	addLayer()
	animatePolyline()
    }

    func addLayer() {
	var coordinates = [CLLocationCoordinate2D]()

	let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))

	let source = MGLGeoJSONSource(identifier: "polyline", features: [polyline], options: nil)

	let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
	layer.lineJoin = MGLStyleValue(rawValue: NSValue(MGLLineJoin: .Round))
	layer.lineCap = MGLStyleValue(rawValue: NSValue(MGLLineCap: .Round))
	layer.lineColor = MGLStyleValue(rawValue: UIColor.redColor())
	layer.lineWidth = MGLStyleFunction(base: 1.5, stops: [
	    14: MGLStyleConstantValue(rawValue: 5),
	    18: MGLStyleConstantValue(rawValue: 20),
	])

	self.mapView.style().addSource(source)
	self.mapView.style().addLayer(layer)

	self.polylineSource = source
    }

    func animatePolyline() {
	self.currentIndex = 0

	self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    func tick() {
	guard let source = self.polylineSource else { return }

	if self.currentIndex == allCoordinates.count {
	    self.timer?.invalidate()
	    self.timer = nil
	    return
	}

	var coordinates = Array(allCoordinates[0..<currentIndex])

	let polyline = MGLPolylineFeature(coordinates: &coordinates, count: UInt(coordinates.count))

	source.features = [polyline]

	self.currentIndex += 1
    }
}
#endif