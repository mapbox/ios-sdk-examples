import Mapbox

@objc(FeatureSelectionExample_Swift)

class FeatureSelectionExample_Swift: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var mapView: MGLMapView!
    let layerIdentifier = "state-layer"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 39.23225, longitude: -97.91015), animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(mapView)
        
        // Add a tap gesture recognizer to the map view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(gesture)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Load a tileset containing U.S. states and their population density. For more information about working with tilesets, see: https://www.mapbox.com/help/studio-manual-tilesets/
        let url = URL(string: "mapbox://examples.69ytlgls")!
        let source = MGLVectorTileSource(identifier: "state-source", configurationURL: url)
        style.addSource(source)
        
        let layer = MGLFillStyleLayer(identifier: layerIdentifier, source: source)
        
        // Access the tileset layer.
        layer.sourceLayerIdentifier = "stateData_2-dx853g"
        
        // Create a stops dictionary. This defines the relationship between population density and a UIColor.
        let stops = [0: UIColor.yellow,
                     600: UIColor.red,
                     1200: UIColor.blue]
        
        // Style the fill color using the stops dictionary, exponential interpolation mode, and the feature attribute name.
        // TODO: Default value - UIColor.white
        layer.fillColor = NSExpression(format: "FUNCTION(density, 'mgl_interpolateWithCurveType:parameters:stops:', 'linear', nil, %@)", stops)
        
        // Insert the new layer below the Mapbox Streets layer that contains state border lines. See the layer reference for more information about layer names: https://www.mapbox.com/vector-tiles/mapbox-streets-v7/
        let symbolLayer = style.layer(withIdentifier: "admin-3-4-boundaries")
        style.insertLayer(layer, below: symbolLayer!)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        // Get the CGPoint where the user tapped.
        let spot = gesture.location(in: mapView)
        
        // Access the features at that point within the state layer.
        let features = mapView.visibleFeatures(at: spot, styleLayerIdentifiers: Set([layerIdentifier]))
        
        // Get the name of the selected state.
        if let feature = features.first, let state = feature.attribute(forKey: "name") as? String {
            changeOpacity(name: state)
        } else {
            changeOpacity(name: "")
        }
    }
    
    func changeOpacity(name: String) {
        let layer = mapView.style?.layer(withIdentifier: layerIdentifier) as! MGLFillStyleLayer
        
        // Check if a state was selected, then change the opacity of the states that were not selected.
        if name.count > 0 {
            // TODO: IDEK
            layer.fillOpacity = NSExpression(format: "TERNARY(FUNCTION(name, 'stringValue') = %@, 1, 0)", name)
        } else {
            // Reset the opacity for all states if the user did not tap on a state.
            layer.fillOpacity = NSExpression(forConstantValue: 1)
        }
    }
    
}
