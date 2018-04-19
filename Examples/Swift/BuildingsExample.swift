import Mapbox

@objc(BuildingsExample_Swift)

class BuildingsExample: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map style to Mapbox Light Style version 9. The map's source will be queried later in this example.
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Center the map view on the Colosseum in Rome, Italy and set the camera's pitch and distance.
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922), fromDistance: 600, pitch: 60, heading: 0)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        if let source = style.source(withIdentifier: "composite") {
            let layer = MGLFillExtrusionStyleLayer(identifier: "buildings", source: source)
            layer.sourceLayerIdentifier = "building"
            
            // Filter out buildings that should not extrude.
            layer.predicate = NSPredicate(format: "extrude == 'true'")
            
            // Set the fill extrusion height to the value for the building height attribute.
            layer.fillExtrusionHeight = NSExpression(forKeyPath: "height")
            layer.fillExtrusionBase = NSExpression(forKeyPath: "min_height")
            layer.fillExtrusionOpacity = NSExpression(forConstantValue: 0.75)
            layer.fillExtrusionColor = NSExpression(forConstantValue: UIColor.white)
            
            // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
}
