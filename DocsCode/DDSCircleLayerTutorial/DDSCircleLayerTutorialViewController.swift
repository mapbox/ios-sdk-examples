import UIKit
import Mapbox

class DDSCircleLayerTutorialViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.971, longitude: -93.261), animated: false)
        mapView.zoomLevel = 10
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        let source = MGLVectorTileSource(identifier: "historical-places", configurationURL: URL(string: "mapbox://examples.5zzwbooj")!)
        
        style.addSource(source)
        
        let layer = MGLCircleStyleLayer(identifier: "landmarks", source: source)
        
        layer.sourceLayerIdentifier = "HPC_landmarks-b60kqn"
        
        layer.circleColor = NSExpression(forConstantValue: UIColor(red: 0.67, green: 0.28, blue: 0.13, alpha: 1.0))
        
        layer.circleOpacity = NSExpression(forConstantValue: 0.8)
        
        let zoomStops = [
            10: NSExpression(format: "(Constructi - 2018) / 30"),
            13: NSExpression(format: "(Constructi - 2018) / 10")
        ]
        
        layer.circleRadius = NSExpression(format: "FUNCTION($zoomLevel, 'mgl_interpolateWithCurveType:parameters:stops:', 'linear', nil, %@)", zoomStops)
        
        style.addLayer(layer)
    }
}
