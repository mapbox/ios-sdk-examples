import Mapbox

@objc(SelectFeatureExample_Swift)

class SelectFeatureExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var selectedFeaturesSource: MGLShapeSource?
    var streetsSource: MGLShapeSource!
    var streetsLayer: MGLLineStyleLayer?
    var shapes: MGLShapeCollectionFeature!

    let roadLayers: Set<String> = [
        "road-minor-low",
        "road-street-low",
        "road-major-link",
        "road-minor",
        "road-street",
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736), zoomLevel: 14, animated: false)
        mapView.delegate = self
        mapView.debugMask = [.tileBoundariesMask, .tileInfoMask]
        view.addSubview(mapView)

    }

    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let visibleFeatures: [MGLShape] = mapView.visibleFeatures(in: mapView.bounds, styleLayerIdentifiers: roadLayers, predicate: NSPredicate(format: "type != %@", "footway")).compactMap { $0 as? MGLShape }
        let shapes = MGLShapeCollectionFeature(shapes: visibleFeatures)
        selectedFeaturesSource?.shape = shapes

        // Update our MGLShapeSource to match our selected features.
        selectedFeaturesSource?.shape = shapes
    }

    func mapView(_ didFinishLoadingmapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Create a placeholder MGLShapeSource that will hold copies of any features we’ve selected.
        let selectedFeaturesSource = MGLShapeSource(identifier: "selected-features", features: [], options: nil)
        style.addSource(selectedFeaturesSource)

        // Keep a reference to the source so we can update it when the map is tapped.
        self.selectedFeaturesSource = selectedFeaturesSource

        // Color any selected features red on the map.
        let selectedFeaturesLayer = MGLLineStyleLayer(identifier: "selected-features", source: selectedFeaturesSource)
        selectedFeaturesLayer.lineColor = NSExpression(forConstantValue: UIColor.red)

        style.addLayer(selectedFeaturesLayer)
    }
}
