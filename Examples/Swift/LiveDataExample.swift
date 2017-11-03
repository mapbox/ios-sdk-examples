import Mapbox

@objc(LiveDataExample_Swift)

class LiveDataExample: UIViewController, MGLMapViewDelegate {
    
    var source : MGLShapeSource!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        mapView.tintColor = .gray
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle)
    {
        if let url = URL(string: "https://wanderdrone.appspot.com/") {
            // Add a source to the map. https://wanderdrone.appspot.com/ generates coordinates for simulated paths.
            source = MGLShapeSource(identifier: "drone-source", url: url, options: nil)
            style.addSource(source)
            
            // Add an icon to the map to represent the drone's coordinate.
            let droneLayer = MGLSymbolStyleLayer(identifier: "drone-layer", source: source)
            droneLayer.iconImageName = MGLStyleValue(rawValue: "rocket-15")
            droneLayer.iconHaloColor = MGLStyleValue(rawValue: .white)
            style.addLayer(droneLayer)
            
            // Create a timer that calls the `updateUrl` function every 1.5 seconds.
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateUrl), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateUrl() {
        // Update the icon's position by updating the `url` property on the source.
        if let url = URL(string: "https://wanderdrone.appspot.com/") {
            source.url = url
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Invalidate the timer if the view will disappear.
        timer.invalidate()
        timer = Timer()
    }
}
