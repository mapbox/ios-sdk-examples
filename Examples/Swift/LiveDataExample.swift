import Mapbox

@objc(LiveDataExample_Swift)

class LiveDataExample: UIViewController, MGLMapViewDelegate {

    var source: MGLShapeSource!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new map view using the Mapbox Dark style.
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray

        // Set the map view‘s delegate property.
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let url = URL(string: "https://wanderdrone.appspot.com/") {
            // Add a source to the map. https://wanderdrone.appspot.com/ generates coordinates for simulated paths.
            source = MGLShapeSource(identifier: "wanderdrone", url: url, options: nil)
            style.addSource(source)

            // Add a Maki icon to the map to represent the drone's coordinate. The specified icon is included in the Mapbox Dark style's sprite sheet. For more information about Maki icons, see https://www.mapbox.com/maki-icons/
            let droneLayer = MGLSymbolStyleLayer(identifier: "wanderdrone", source: source)
            droneLayer.iconImageName = NSExpression(forConstantValue: "rocket-15")
            droneLayer.iconHaloColor = NSExpression(forConstantValue: UIColor.white)
            style.addLayer(droneLayer)

            // Create a timer that calls the `updateUrl` function every 1.5 seconds.
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateUrl), userInfo: nil, repeats: true)
        }
    }

    @objc func updateUrl() {
        // Update the icon's position by setting the `url` property on the source.
        source.url = source.url
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Invalidate the timer if the view will disappear.
        timer.invalidate()
        timer = Timer()
    }
}
