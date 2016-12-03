//
//  SelectFeatureExample2.3.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if !swift(>=3.0)
import Mapbox

@objc(SelectFeatureExample_Swift)

class SelectFeatureExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var selectedFeaturesSource: MGLGeoJSONSource?

    override func viewDidLoad() {
	super.viewDidLoad()

	let mapView = MGLMapView(frame: view.bounds)
	mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

	// Set the map’s center coordinate and zoom level.
	mapView.setCenterCoordinate(
	    CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736),
	    zoomLevel: 11,
	    animated: false)
	view.addSubview(mapView)

	let tapGR = UITapGestureRecognizer(target: self, action: #selector(SelectFeatureExample_Swift.didTapMap(_:)))
	tapGR.numberOfTapsRequired = 1
	tapGR.numberOfTouchesRequired = 1
	mapView.addGestureRecognizer(tapGR)

	mapView.delegate = self

	self.mapView = mapView
    }

    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	let selectedFeaturesSource = MGLGeoJSONSource(identifier: "selected-features", features: [], options: nil)
	let selectedFeaturesLayer = MGLFillStyleLayer(identifier: "selected-features", source: selectedFeaturesSource)
	selectedFeaturesLayer.fillColor = MGLStyleValue(rawValue: UIColor.redColor())

	style.addSource(selectedFeaturesSource)
	style.addLayer(selectedFeaturesLayer)

	self.selectedFeaturesSource = selectedFeaturesSource
    }

    func didTapMap(tapGestureRecognizer: UITapGestureRecognizer) {
	if tapGestureRecognizer.state == .Ended {
	    let point = tapGestureRecognizer.locationInView(tapGestureRecognizer.view!)
	    let touchRect = CGRectInset(CGRect(origin: point, size: CGSizeZero), -22.0, -22.0)
	    var features = [MGLFeature]()
	    for f in mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: ["park"]) {
		features.append(f)
	    }
	    selectedFeaturesSource?.features = features
	}
    }


}
#endif
