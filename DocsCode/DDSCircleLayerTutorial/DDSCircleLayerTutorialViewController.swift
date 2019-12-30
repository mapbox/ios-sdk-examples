import UIKit
import Mapbox

class DDSCircleLayerTutorialViewController: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.971, longitude: -93.261), zoomLevel: 10, animated: false)

        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        let source = MGLVectorTileSource(identifier: "historical-places", configurationURL: URL(string: "mapbox://examples.5zzwbooj")!)

        style.addSource(source)

        let layer = MGLCircleStyleLayer(identifier: "landmarks", source: source)

        layer.sourceLayerIdentifier = "HPC_landmarks-b60kqn"

        layer.circleColor = NSExpression(forConstantValue: #colorLiteral(red: 0.67, green: 0.28, blue: 0.13, alpha: 1))

        layer.circleOpacity = NSExpression(forConstantValue: 0.8)

        let zoomStops = [
            10: NSExpression(format: "(2018 - Constructi) / 30"),
            13: NSExpression(format: "(2018 - Constructi) / 10")
        ]

        layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", zoomStops)

        style.addLayer(layer)
    }
}
