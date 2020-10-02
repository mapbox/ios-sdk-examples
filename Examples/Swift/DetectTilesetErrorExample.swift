import Mapbox

@objc(DetectTilesetErrorExample_Swift)

class DetectTilesetErrorExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var contoursLayer: MGLStyleLayer?
    var observer: MyObserver?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        observer = MyObserver()
        mapView.subscribe(for: observer!, event: .resourceRequest)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.745395, longitude: -119.594421), zoomLevel: 11, animated: false)
        view.addSubview(mapView)

        mapView.delegate = self
    }

    /// We strongly recommending unsubscribing from the observer
    deinit {
        if let observer = observer {
            mapView.unsubscribe(for: observer)
        }
    }

    // Wait until the style is loaded before modifying the map style
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        addLayer(to: style)
    }

    func addLayer(to style: MGLStyle) {
        let source = MGLVectorTileSource(identifier: "contours", configurationURL: NSURL(string: "mapbox://badtilesource")! as URL)
        let layer = MGLLineStyleLayer(identifier: "contours", source: source)
        style.addSource(source)
        style.addLayer(layer)
    }
}

class MyObserver: MGLObserver {
    override func notify(with event: MGLEvent) {
        super.notify(with: event)
        guard let data = event.data as? [String: Any] else {
            return
        }
        guard let request = data["request"] as? [String: Any] else {
            return
        }
        guard let dataSource = data["data-source"] as? String else {
            return
        }
        if dataSource != "network" {
            return
        }
        guard let response = data["response"] as? [String: Any] else {
            return
        }
        guard let error = response["error"] as? [String: Any] else {
            return
        }
        print("network request: \(request), errors: \(error)")
    }
}
