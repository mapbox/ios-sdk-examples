
import Mapbox

@objc(LightExample_Swift)

class LightExample: UIViewController, MGLMapViewDelegate {
    
    var sliderValue = 0.0
    
    var mapView : MGLMapView!
    var light : MGLLight!
    var lightValue = 0
    var lightIntensity = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL())
        mapView.delegate = self
        
        // Flatiron Building
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 40.7411, longitude: -73.9897), fromDistance: 600, pitch: 45, heading: 240)
        //        slider.tintColor = .darkGray
        mapView.tintColor = .gray
        view.addSubview(mapView)
        
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
    {
        
        // Add Building Fill Extrusions
        addFillExtrusions(style: style)
        
        // Adjust Light
        setLight(style: style)
        //        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeZoom), userInfo: nil, repeats: true)
    }
    
    func addFillExtrusions(style: MGLStyle) {
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
    
    func setLight(style: MGLStyle) {
        light = MGLLight()
        let position = MGLSphericalPositionMake(6, 210, 00);
        light.position = MGLStyleValue<NSValue>(rawValue: NSValue(mglSphericalPosition: position))
        light.positionTransition = MGLTransition(duration: 5, delay: 0)
        light.intensity = MGLStyleValue<NSValue>(rawValue: NSNumber(value: lightIntensity)) as! MGLStyleValue<NSNumber>
        style.light = light
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(shiftLight), userInfo: nil, repeats: true)
    }
    
    @objc func shiftLight() {
        lightValue = (lightValue % 180) + 30
        light = MGLLight()
        let position = MGLSphericalPositionMake(6, 210, CLLocationDirection(lightValue))
        light.position = MGLStyleValue<NSValue>(rawValue: NSValue(mglSphericalPosition: position))
        //        if lightIntensity < 1 {
        //            lightIntensity += 0.1
        //        } else {
        //            lightIntensity = 0
        //        }
        //        light.intensity = MGLStyleValue<NSValue>(rawValue: NSNumber(value: lightIntensity)) as! MGLStyleValue<NSNumber>
        
        mapView.style?.light = light
        print(lightValue)
        
        //        print(lightIntensity)
    }
}
