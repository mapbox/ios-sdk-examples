import UIKit
import Mapbox

class DDSCircleLayerTutorialViewController: UIViewController, MGLMapViewDelegate {
    
    // #-code-snippet: dds-circle initialize-map-swift
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new map view using the Mapbox Light style.
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.897, longitude: -77.039), zoomLevel: 10.5, animated: false)
        
        view.addSubview(mapView)
        mapView.delegate = self
    }
    // #-end-code-snippet: dds-circle initialize-map-swift

    
    // Wait until the style is loaded before modifying the map style.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // #-code-snippet: dds-circle add-vector-source-swift
        // "mapbox://examples.2uf7qges" is the map ID referencing a tileset
        // created from the GeoJSON data uploaded earlier.
        let source = MGLVectorSource(identifier: "trees", configurationURL: URL(string: "mapbox://examples.2uf7qges")!)
        
        style.addSource(source)
        // #-end-code-snippet: dds-circle add-vector-source-swift
        
        // #-code-snippet: dds-circle add-circle-layer-swift
        let layer = MGLCircleStyleLayer(identifier: "tree-style", source: source)
    
        // The source name from the source's TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
        layer.sourceLayerIdentifier = "yoshino-trees-a0puw5"
        // #-end-code-snippet: dds-circle add-circle-layer-swift
    
        // #-code-snippet: dds-circle add-stops-dictionary-swift
        let stops = [
            0: MGLStyleValue(rawValue: UIColor(red:1.00, green:0.72, blue:0.85, alpha:1.0)),
            2: MGLStyleValue(rawValue: UIColor(red:0.69, green:0.48, blue:0.73, alpha:1.0)),
            4: MGLStyleValue(rawValue: UIColor(red:0.61, green:0.31, blue:0.47, alpha:1.0)),
            7: MGLStyleValue(rawValue: UIColor(red:0.43, green:0.20, blue:0.38, alpha:1.0)),
            16: MGLStyleValue(rawValue: UIColor(red:0.33, green:0.17, blue:0.25, alpha:1.0))
        ]
        // #-end-code-snippet: dds-circle add-stops-dictionary-swift
        
        // #-code-snippet: dds-circle add-style-layer-swift
        layer.circleColor = MGLStyleValue<UIColor>(interpolationMode: .interval,
                                                   sourceStops: stops,
                                                   attributeName: "AGE",
                                                   options: nil)
        
        layer.circleRadius = MGLStyleValue(rawValue: 3)
        
        style.addLayer(layer)
        // #-end-code-snippet: dds-circle add-style-layer-swift
    }
}
