
import Mapbox

@objc(ImageSourceExample_Swift)

class ImageSourceExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL())
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 43.457, longitude: -75.789), zoomLevel: 4, animated: false)
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Set the corners of the image.
        let coordinates = MGLCoordinateQuad(
            topLeft: CLLocationCoordinate2D(latitude: 46.437, longitude: -80.425),
            bottomLeft: CLLocationCoordinate2D(latitude: 37.936, longitude: -80.425),
            bottomRight: CLLocationCoordinate2D(latitude: 37.936, longitude: -71.516),
            topRight: CLLocationCoordinate2D(latitude: 46.437, longitude: -71.516))
        
        // Create a MGLImageSource that uses
        let source = MGLImageSource(identifier: "radar", coordinateQuad: coordinates, url: URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/radar.gif")!)
        style.addSource(source)
        
        // Create a raster layer from the MGLImageSource.
        let radarLayer = MGLRasterStyleLayer(identifier: "radar-layer", source: source)
        
        // Insert the image below the map's symbol layers.
        for layer in style.layers.reversed() {
            if !layer.isKind(of: MGLSymbolStyleLayer.self) {
                style.insertLayer(radarLayer, above: layer)
                break
            }
        }
    }
}
