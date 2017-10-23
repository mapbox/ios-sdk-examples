
import Mapbox

@objc(ImageSourceExample_Swift)

class ImageSourceExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 43.457, longitude: -76.437), zoomLevel: 4, animated: false)
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let coordinates = MGLCoordinateQuad(
            topLeft: CLLocationCoordinate2D(latitude: 46.437, longitude: -80.425),
            bottomLeft: CLLocationCoordinate2D(latitude: 37.936, longitude: -80.425),
            bottomRight: CLLocationCoordinate2D(latitude: 37.936, longitude: -71.516),
            topRight: CLLocationCoordinate2D(latitude: 46.437, longitude: -71.516))
        let source = MGLImageSource(identifier: "radar", coordinateQuad: coordinates, url: URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/radar.gif")!)
        style.addSource(source)
        
        let layer = MGLRasterStyleLayer(identifier: "radar-layer", source: source)
        style.addLayer(layer)
    }
}
