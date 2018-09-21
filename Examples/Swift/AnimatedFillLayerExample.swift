import Mapbox

@objc(AnimatedFillLayerExample_Swift)
class AnimatedFillLayerExample_Swift: UIViewController, MGLMapViewDelegate {
    
    private var mapView: MGLMapView!
    private var radarLayer: MGLFillStyleLayer?
    private var timer: Timer?
    private var _timeIndex: Int = 0
    private var timeIndex: Int {
        get {
            return _timeIndex
        }
        set {
            let value = newValue >= 37 ? 0 : newValue
            _timeIndex = value
        }
    }

    // Convert RGB values to UIColor.
    private func RGB(_ red: Int, _ green: Int, _ blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/256.0, green: CGFloat(green)/256.0, blue: CGFloat(blue)/256.0, alpha: 1);
    }
    
    // Create a stops dictionary. This will be used to determine the color of polygons within the fill layer.
    private var fillColors : [Int: UIColor] {
        return [
            8: RGB(20, 160, 240),
            18: RGB(20, 190, 240),
            36: RGB(20, 220, 240),
            54: RGB(20, 250, 240),
            72: RGB(20, 250, 160),
            90: RGB(135, 250, 80),
            108: RGB(250, 250, 0),
            126: RGB(250, 180, 0),
            144: RGB(250, 110, 0),
            162: RGB(250, 40, 0),
            180: RGB(180, 40, 40),
            198: RGB(110, 40, 80),
            216: RGB(80, 40, 110),
            234: RGB(50, 40, 140),
            252: RGB(20, 40, 170)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create and add a map view.
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
       // Center the map on China.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.22894, longitude: 102.45434), zoomLevel: 2, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Access a tileset that contains multiple polygons. This radar data was retrieved from the China Meteorological Data Service Center on June 26, 2018. "mapbox://examples.dwtmhwpu" is a map id that references a tileset mapbox.com/help/define-map-id/
        guard let url = URL(string: "mapbox://examples.dwtmhwpu") else {
            return;
        }
        
        // Create a MGLVectorTileSource from the vector tileset and add it to the map's style.
        let source = MGLVectorTileSource(identifier: "weather-source", configurationURL: url)
        style.addSource(source)
        
        // Create a fill layer from the vector tileset. The fill layer is a visual representation of the tileset.
        let fillLayer = MGLFillStyleLayer(identifier: "weather-layer", source: source)
        
        // The source layer identifier comes from the source's TileJSON metadata: mapbox.com/api-documentation/#retrieve-tilejson-metadata
        fillLayer.sourceLayerIdentifier = "201806261518"
        
        // Use the stops dictionary created earlier to determine the fill layer's color. The stops dictionary uses values for the `value` attribute as a key, and UIColor objects as the values.
        fillLayer.fillColor = NSExpression(format: "mgl_step:from:stops:(value, %@, %@)", UIColor.clear, self.fillColors)
        fillLayer.fillOpacity = NSExpression(forConstantValue: 0.7)
        fillLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.clear)
        fillLayer.predicate = NSPredicate(format: "idx == %d", timeIndex)
        style.addLayer(fillLayer)
        
        // Store the layer as a property in order to update it later. If your use case involves style changes, do not store the layer as a property. Instead, access the layer using its layer identifier.
        self.radarLayer = fillLayer
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func timerTick() {
        guard let layer = self.radarLayer else {
            return
        }
        layer.predicate = NSPredicate(format: "idx == %d", timeIndex)
        timeIndex = timeIndex + 1
    }
}
