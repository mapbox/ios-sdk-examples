//
//  SelectFeatureExample.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
import Mapbox

@objc(SelectFeatureExample_Swift)

class SelectFeatureExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var selectedFeaturesSource: MGLGeoJSONSource?

    override func viewDidLoad() {
	super.viewDidLoad()

	let mapView = MGLMapView(frame: view.bounds)
	mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

	// Set the map’s center coordinate and zoom level.
	mapView.setCenter(
	    CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736),
	    zoomLevel: 11,
	    animated: false)
	view.addSubview(mapView)

	let tapGR = UITapGestureRecognizer(target: self, action: #selector(SelectFeatureExample_Swift.didTapMap(tapGestureRecognizer:)))
	tapGR.numberOfTapsRequired = 1
	tapGR.numberOfTouchesRequired = 1
	mapView.addGestureRecognizer(tapGR)

	mapView.delegate = self

	self.mapView = mapView
    }

    func mapView(_ didFinishLoadingmapView: MGLMapView, didFinishLoading style: MGLStyle) {
	let selectedFeaturesSource = MGLGeoJSONSource(identifier: "selected-features", features: [], options: nil)
	let selectedFeaturesLayer = MGLFillStyleLayer(identifier: "selected-features", source: selectedFeaturesSource)
	selectedFeaturesLayer.fillColor = MGLStyleValue(rawValue: UIColor.red)

	style.add(selectedFeaturesSource)
	style.add(selectedFeaturesLayer)

	self.selectedFeaturesSource = selectedFeaturesSource
    }

    func didTapMap(tapGestureRecognizer: UITapGestureRecognizer) {
	if tapGestureRecognizer.state == .ended {
	    let point = tapGestureRecognizer.location(in: tapGestureRecognizer.view!)
	    let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
	    var features = [MGLFeature]()
	    for f in mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: ["park"]) {
		features.append(f)
	    }
	    selectedFeaturesSource?.features = features
	}
    }


}
#endif
