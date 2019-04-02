import UIKit
import Mapbox

@objc(LabelPlacementExample_Swift)

class LabelPlacementExample: UIViewController {
    
    let mapView = MGLMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map's initial style, center coordinate, and zoom level
        mapView.styleURL = MGLStyle.streetsStyleURL
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.791282, longitude: -122.396301), zoomLevel: 15.0, animated: false)
        mapView.delegate = self
        view.addSubview(mapView)
    }

}

extension LabelPlacementExample: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let poiLabelLayers = style.layer(withIdentifier: "poi-label") as? MGLSymbolStyleLayer {
            poiLabelLayers.textAnchor = nil
            poiLabelLayers.textOffset = nil
            poiLabelLayers.symbolPlacement = nil
            poiLabelLayers.textOffset = nil
//            poiLabelLayers.textVariableAnchor = NSExpression(forConstantValue: [MGLTextAnchor.top, MGLTextAnchor.right])
//            poiLabelLayers.textRadialOffset = NSExpression(forConstantValue: 1.2)
//            poiLabelLayers.textJustification = NSExpression(forConstantValue: MGLTextJustification.auto)
        }
    }
}
