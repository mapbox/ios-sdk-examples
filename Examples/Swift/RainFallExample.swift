import Mapbox

@objc(RainFallExample_Swift)
class RainFallExample_Swift: UIViewController, MGLMapViewDelegate {
    
    private var mapView: MGLMapView!
    private var slider: UISlider!
    private var radarLayer: MGLFillStyleLayer?
    private var timer: Timer?
    
    private func RGB(_ red: Int, _ green: Int, _ blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/256.0, green: CGFloat(green)/256.0, blue: CGFloat(blue)/256.0, alpha: 1);
    }
    
    private var timeIndex: Int {
        get {
            return Int(floor(slider.value))
        }
        set {
            let value = newValue >= 40 ? 0 : newValue
            slider.value = Float(value)
        }
    }
    
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
    
    deinit {
        if let timer = self.timer {
            timer.invalidate()
        }
        NotificationCenter.default.removeObserver(self)
    }

    private func perfectSliderFrame() -> CGRect {
        if (UIApplication.shared.statusBarOrientation == .portrait) {
            return CGRect(x: 10,
                          y: view.frame.height - 60 - self.bottomLayoutGuide.length,
                          width: view.frame.width - 20,
                          height: 20)
        }
        return CGRect(x: self.topLayoutGuide.length,
                      y: view.frame.height - 60 - self.bottomLayoutGuide.length,
                      width: view.frame.width - self.topLayoutGuide.length*2,
                      height: 20)
    }
    
    @objc private func didChangeOrientation() {
        UIView.animate(withDuration: 0.3) {
            self.slider.frame = self.perfectSliderFrame()
        }
    }
    
    @objc private func timerTick() {
        guard let layer = self.radarLayer else {
            return
        }
        timeIndex = timeIndex + 1
        layer.predicate = NSPredicate(format: "idx == %d", timeIndex)
    }
    
    @objc private func slideValueChanged(_ slider: UISlider, event: UIEvent) {
        guard let layer = self.radarLayer else {
            return
        }
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                timer?.invalidate()
            case .ended:
                timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            default:
                break
            }
        }
        
        layer.predicate = NSPredicate(format: "idx == %d", timeIndex)
    }
    
    private func addMapView() {
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.22894310302858, longitude: 102.45434471254349), zoomLevel: 2, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func addSlider() {
        slider = UISlider()
        slider.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        slider.minimumValue = 0
        slider.maximumValue = 40
        slider.value = 0
        slider.addTarget(self, action: #selector(slideValueChanged(_:event:)), for: .valueChanged)

        view.addSubview(slider)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.slider.frame = self.perfectSliderFrame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMapView()
        self.addSlider()
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrientation), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        guard let url = URL(string: "mapbox://shenhongissky.6vm8ssjm") else {
            return;
        }
        
        let source = MGLVectorTileSource(identifier: "moji-source", configurationURL: url)
        style.addSource(source)
        let fillLayer = MGLFillStyleLayer(identifier: "moji-layer", source: source)
        fillLayer.sourceLayerIdentifier = "whole"
        fillLayer.fillColor = NSExpression(format: "mgl_step:from:stops:(value, %@, %@)", UIColor.clear, self.fillColors)
        fillLayer.fillOpacity = NSExpression(forConstantValue: 0.7)
        fillLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.clear)
        style.addLayer(fillLayer)
        self.radarLayer = fillLayer
        
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
}
