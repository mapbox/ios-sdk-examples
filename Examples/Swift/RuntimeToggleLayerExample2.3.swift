//
//  RuntimeToggleLayer.swift
//  Examples
//
//  Created by Eric Wolfe on 11/30/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(RuntimeToggleLayerExample_Swift)

class RuntimeToggleLayerExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    var contoursLayer: MGLStyleLayer?

    override func viewDidLoad() {
	super.viewDidLoad()

	mapView = MGLMapView(frame: view.bounds)
	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 37.745395, longitude: -119.594421), zoomLevel: 11, animated: false)
	view.addSubview(mapView)

	addToggleButton()

	mapView.delegate = self
    }

    // Wait until the style is loaded before modifying the map style
    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	addLayer()
    }

    func addLayer() {
	let source = MGLVectorSource(identifier: "contours", URL: NSURL(string: "mapbox://mapbox.mapbox-terrain-v2")!)

	let layer = MGLLineStyleLayer(identifier: "contours", source: source)
	layer.sourceLayerIdentifier = "contour"
	layer.lineJoin = MGLStyleValue(rawValue: NSValue(MGLLineJoin: .Round))
	layer.lineCap = MGLStyleValue(rawValue: NSValue(MGLLineCap: .Round))
	layer.lineColor = MGLStyleValue(rawValue: UIColor.brownColor())
	layer.lineWidth = MGLStyleValue(rawValue: 1.0)

	self.mapView.style().addSource(source)
	if let water = self.mapView.style().layerWithIdentifier("water") {
	    // You can insert a layer below an existing style layer
	    self.mapView.style().insertLayer(layer, belowLayer: water)
	} else {
	    // or you can simply add it above all layers
	    self.mapView.style().addLayer(layer)
	}

	self.contoursLayer = layer

	showContours()
    }

    func toggleLayer(sender: UIButton) {
	sender.selected = !sender.selected
	if sender.selected {
	    showContours()
	} else {
	    hideContours()
	}
    }

    func showContours() {
	self.contoursLayer?.visible = true
    }

    func hideContours() {
	self.contoursLayer?.visible = false
    }

    func addToggleButton() {
	let button = UIButton(type: .System)
	button.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
	button.setTitle("Toggle Contours", forState: .Normal)
	button.selected = true
	button.sizeToFit()
	button.center.x = self.view.center.x
	button.frame = CGRect(origin: CGPoint(x: button.frame.origin.x, y: self.view.frame.size.height - button.frame.size.height - 5), size: button.frame.size)
	button.addTarget(self, action: #selector(RuntimeToggleLayerExample_Swift.toggleLayer(_:)), forControlEvents: .TouchUpInside)
	self.view.addSubview(button)
    }
}
#endif
