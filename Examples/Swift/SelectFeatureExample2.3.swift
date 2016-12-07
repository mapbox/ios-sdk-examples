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

	// Add our own gesture recognizer to handle taps on our custom map features
	mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectFeatureExample_Swift.didTapMap(_:))))

	mapView.delegate = self

	self.mapView = mapView
    }

    func mapView(mapView: MGLMapView, didFinishLoadingStyle style: MGLStyle) {
	// Create a placeholder MGLGeoJSONSource that will hold copies of any features we've selected
	let selectedFeaturesSource = MGLGeoJSONSource(identifier: "selected-features", features: [], options: nil)
	style.addSource(selectedFeaturesSource)

	// Keep a reference to the source so we can update it when the map is tapped
	self.selectedFeaturesSource = selectedFeaturesSource

	// Color any selected features red on the map
	let selectedFeaturesLayer = MGLFillStyleLayer(identifier: "selected-features", source: selectedFeaturesSource)
	selectedFeaturesLayer.fillColor = MGLStyleValue(rawValue: UIColor.redColor())

	style.addLayer(selectedFeaturesLayer)
    }

    func didTapMap(tapGestureRecognizer: UITapGestureRecognizer) {
	if tapGestureRecognizer.state == .Ended {
	    // A tap's center coordinate may not intersect a feature exactly, so let's make a 44x44 rect that represents a touch and select all features that interesect
	    let point = tapGestureRecognizer.locationInView(tapGestureRecognizer.view!)
	    let touchRect = CGRectInset(CGRect(origin: point, size: CGSizeZero), -22.0, -22.0)

	    // Let's only select parks near the rect. There's a layer within the Mapbox Streets style with "id" = "park". You can see all of the layers used within the default mapbox styles by creating a new style using http://mapbox.com/studio
	    let layerIdentifiers = Set(["park"])

	    // Query the current mapview for any features that intersect our rect
	    var features = [MGLFeature]()
	    for f in mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: layerIdentifiers) {
		features.append(f)
	    }

	    // Update our MGLGeoJSONSource to match our selected features
	    selectedFeaturesSource?.features = features
	}
    }


}
#endif
