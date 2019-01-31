import Mapbox

@objc(SelectFeatureExample_Swift)

class SelectFeatureExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var selectedFeaturesSource: MGLShapeSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736), zoomLevel: 11, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)

        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }

    func mapView(_ didFinishLoadingmapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Create a placeholder MGLShapeSource that will hold copies of any features we’ve selected.
        let selectedFeaturesSource = MGLShapeSource(identifier: "selected-features", features: [], options: nil)
        style.addSource(selectedFeaturesSource)

        // Keep a reference to the source so we can update it when the map is tapped.
        self.selectedFeaturesSource = selectedFeaturesSource

        // Color any selected features red on the map.
        let selectedFeaturesLayer = MGLFillStyleLayer(identifier: "selected-features", source: selectedFeaturesSource)
        selectedFeaturesLayer.fillColor = NSExpression(forConstantValue: UIColor.red)

        style.addLayer(selectedFeaturesLayer)
    }

    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) throws {
        if sender.state == .ended {
            // A tap’s center coordinate may not intersect a feature exactly, so let’s make a 44x44 rect that represents a touch and select all features that intersect.
            let point = sender.location(in: sender.view!)
            let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)

            // Let’s only select parks near the rect. There’s a layer within the Mapbox Streets style with "id" = "water". You can see all of the layers used within the default mapbox styles by creating a new style using Mapbox Studio.
            let layerIdentifiers = Set(["water"])

            // Query the map view for any visible features that intersect our rect.
            guard let features = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: layerIdentifiers) as? [MGLShape & MGLFeature] else {
                fatalError("Could not cast to specified MGLShape/MGLFeature")
            }
            let shapes = MGLShapeCollectionFeature(shapes: features)

            // Update our MGLShapeSource to match our selected features.
            selectedFeaturesSource?.shape = shapes
        }
    }

}
