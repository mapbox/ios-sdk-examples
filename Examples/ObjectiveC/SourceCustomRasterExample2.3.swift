//
//  SourceCustomRasterExample2.3.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(SourceCustomRasterExample_Swift)

class SourceCustomRasterExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    var rasterLayer: MGLRasterStyleLayer?

    override func viewDidLoad() {
	super.viewDidLoad()


	mapView = MGLMapView(frame: view.bounds, styleURL: nil)

	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	// Set the map’s center coordinate and zoom level.
	mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)

	view.addSubview(mapView)

	let padding: CGFloat = 10
	let slider = UISlider(frame: CGRect(x: padding, y: self.view.frame.size.height - 44 - 30, width: self.view.frame.size.width - padding *  2, height: 44))
	slider.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin]
	slider.minimumValue = 0
	slider.maximumValue = 1
	slider.value = 1
	slider.addTarget(self, action: #selector(SourceCustomRasterExample_Swift.updateLayerOpacity(_:)), forControlEvents: .ValueChanged)
	view.addSubview(slider)

	mapView.delegate = self
    }

    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	// Add a new raster source and layer
	let source = MGLRasterSource(identifier: "stamen-watercolor", tileSet: MGLTileSet(tileURLTemplates: ["https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg"]), tileSize: 256)
	let rasterLayer = MGLRasterStyleLayer(identifier: "stamen-watercolor", source: source)

	mapView.style().addSource(source)
	mapView.style().addLayer(rasterLayer)

	self.rasterLayer = rasterLayer
    }

    func updateLayerOpacity(sender: UISlider) {
	self.rasterLayer?.rasterOpacity = MGLStyleValue(rawValue: sender.value)
    }
}
#endif
