//
//  SourceCustomRasterExample.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
import Mapbox

@objc(SourceCustomRasterExample_Swift)

class SourceCustomRasterExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    var rasterLayer: MGLRasterStyleLayer?

    override func viewDidLoad() {
	super.viewDidLoad()

	mapView = MGLMapView(frame: view.bounds, styleURL: nil)

	mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

	// Set the map’s center coordinate and zoom level.
	mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)

	view.addSubview(mapView)

	// Add a UISlider that will control the raster layer's opacity
	addSlider()

	mapView.delegate = self
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
	// Add a new raster source and layer
	let source = MGLRasterSource(identifier: "stamen-watercolor", tileSet: MGLTileSet(tileURLTemplates: ["https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg"]), tileSize: 256)
	let rasterLayer = MGLRasterStyleLayer(identifier: "stamen-watercolor", source: source)

	mapView.style().add(source)
	mapView.style().add(rasterLayer)

	self.rasterLayer = rasterLayer
    }

    func updateLayerOpacity(sender: UISlider) {
	self.rasterLayer?.rasterOpacity = MGLStyleValue(rawValue: NSNumber(value: sender.value))
    }

    func addSlider() {
	let padding: CGFloat = 10
	let slider = UISlider(frame: CGRect(x: padding, y: self.view.frame.size.height - 44 - 30, width: self.view.frame.size.width - padding *  2, height: 44))
	slider.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
	slider.minimumValue = 0
	slider.maximumValue = 1
	slider.value = 1
	slider.addTarget(self, action: #selector(SourceCustomRasterExample_Swift.updateLayerOpacity(sender:)), for: .valueChanged)
	view.addSubview(slider)
    }
}
#endif
