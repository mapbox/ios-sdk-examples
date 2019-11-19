import Mapbox

@objc(BuildingLightExample_Swift)

class BuildingLightExample: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var light: MGLLight!
    var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the map style to Mapbox Streets Style version 9. The map's source will be queried later in this example.
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        // Center the map on the Flatiron Building in New York, NY.
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 40.7411, longitude: -73.9897), altitude: 1200, pitch: 45, heading: 0)

        view.addSubview(mapView)

        addSlider()
    }

    // Add a slider to the map view. This will be used to adjust the map's light object.
    func addSlider() {
        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        slider.minimumValue = -180
        slider.maximumValue = 180
        let customPurpleColor = UIColor(red: 0.271, green: 0.412, blue: 0.969, alpha: 1.0)
        slider.tintColor = customPurpleColor
        slider.thumbTintColor = customPurpleColor
        slider.value = 0
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(shiftLight), for: .valueChanged)
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75.0)
        ])
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        // Add a MGLFillExtrusionStyleLayer.
        addFillExtrusionLayer(style: style)

        // Create an MGLLight object.
        light = MGLLight()

        // Create an MGLSphericalPosition and set the radial, azimuthal, and polar values.
        // Radial : Distance from the center of the base of an object to its light. Takes a CGFloat.
        // Azimuthal : Position of the light relative to its anchor. Takes a CLLocationDirection.
        // Polar : The height of the light. Takes a CLLocationDirection.
        let position = MGLSphericalPositionMake(5, 180, 80)
        light.position = NSExpression(forConstantValue: NSValue(mglSphericalPosition: position))

        // Set the light anchor to the map and add the light object to the map view's style. The light anchor can be the viewport (or rotates with the viewport) or the map (rotates with the map). To make the viewport the anchor, replace `map` with `viewport`.
        light.anchor = NSExpression(forConstantValue: "map")
        style.light = light
    }

    @objc func shiftLight() {

        // Use the slider's value to change the light's polar value.
        let position = MGLSphericalPositionMake(5, 180, CLLocationDirection(slider.value))
        light.position = NSExpression(forConstantValue: NSValue(mglSphericalPosition: position))
        mapView.style?.light = light
    }

    func addFillExtrusionLayer(style: MGLStyle) {
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        let source = style.source(withIdentifier: "composite")!
        let layer = MGLFillExtrusionStyleLayer(identifier: "extrusion-layer", source: source)
        layer.sourceLayerIdentifier = "building"
        layer.fillExtrusionBase = NSExpression(forKeyPath: "min_height")
        layer.fillExtrusionHeight = NSExpression(forKeyPath: "height")
        layer.fillExtrusionOpacity = NSExpression(forConstantValue: 0.75)
        layer.fillExtrusionColor = NSExpression(forConstantValue: UIColor.white)

        // Access the map's layer with the identifier "poi-scalerank3" and insert the fill extrusion layer below it.
        let symbolLayer = style.layer(withIdentifier: "poi-scalerank3")!
        style.insertLayer(layer, below: symbolLayer)
    }
}
