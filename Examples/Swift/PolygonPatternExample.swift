import Mapbox

@objc(PolygonPatternExample_Swift)

class PolygonPatternExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map’s size, style, center coordinate, zoom level, and tint color.
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.darkStyleURL(withVersion: 9)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.849534447, longitude: -77.039222717), zoomLevel: 8.5, animated: false)
        mapView.tintColor = .lightGray
        
        view.addSubview(mapView)
        
        mapView.delegate = self
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Set the UIImage to be used for the fill pattern.
        let fillPatternImage = UIImage(named: "stripe-pattern")!
        
        // Add the fill pattern image to used by the style layer.
        style.setImage(fillPatternImage, forName: "stripe-pattern")
        
        // "mapbox://examples.0cd7imtl" is a map ID referencing a tileset containing vector data.
        // For more information, see mapbox.com/help/define-map-id/
        let source = MGLVectorTileSource(identifier: "drone-restrictions", configurationURL: URL(string: "mapbox://examples.0cd7imtl")!)
        style.addSource(source)
        
        // Create a style layer using the vector source.
        let layer = MGLFillStyleLayer(identifier: "drone-restrictions-style", source: source)
        
        // Set the source's identifier using the source name retrieved from its
        // TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
        // You can also retrieve the source layer identifier in the Mapbox Studio layers list,
        // if your source data was added using the Mapbox Studio style editor.
         layer.sourceLayerIdentifier = "drone-restrictions-3f6lsg"
        
        // Set the fill pattern and opacity for the style layer. The NSExpression
        // object is a generic container for a style attribute value. In this case,
        // it is a reference to the fillPatternImage.
        layer.fillPattern = NSExpression(forConstantValue: "stripe-pattern")
        layer.fillOpacity = NSExpression(forConstantValue: 0.5)
        
        // Insert the pattern style layer below the layer contining city labels. If the
        // layer is not found, the style layer will be added above all other layers within the
        // Mapbox Dark style. NOTE: The "place-city-sm" layer is specific to the Mapbox Dark style.
        // Refer to the layers list in Mapbox Studio to confirm which layers are available for
        // use when working with a custom style.
        if let cityLabels = style.layer(withIdentifier: "place-city-sm") {
            style.insertLayer(layer, below: cityLabels)
        } else {
            style.addLayer(layer)
        }
    }
}

