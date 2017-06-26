
import Mapbox

@objc(LightExample_Swift)

class LightExample: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL(withVersion: 9))
        mapView.delegate = self
        
        // Center the map on the Flatiron Building in New York, NY.
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 40.7411, longitude: -73.9897), fromDistance: 600, pitch: 45, heading: 200)
        mapView.tintColor = .gray
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
    {
        // Add a MGLFillExtrusionStyleLayer.
        addFillExtrusionLayer(style: style)
        
        // Create an MGLLight object.
        let light = MGLLight()
        
        // Create an MGLSphericalPosition and set the radial, azimuthal, and polar values.
        let position = MGLSphericalPositionMake(5, 180, 80)
        light.position = MGLStyleValue<NSValue>(rawValue: NSValue(mglSphericalPosition: position))
            
        // Set the light anchor to the map and add the light object to the map view's style.
        light.anchor = MGLStyleValue(rawValue: NSValue(mglLightAnchor: MGLLightAnchor.map))
        style.light = light
    }
    
    func addFillExtrusionLayer(style: MGLStyle) {
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        if let source = style.source(withIdentifier: "composite") {
            let layer = MGLFillExtrusionStyleLayer(identifier: "extrusion-layer", source: source)
            layer.sourceLayerIdentifier = "building"
            layer.fillExtrusionBase = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "min_height", options: nil)
            layer.fillExtrusionHeight = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "height", options: nil)
            layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.75)
            layer.fillExtrusionColor = MGLStyleValue(rawValue: .white)
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
}
