import Foundation
import Mapbox

@objc(SymbolLayerZOrderExample_Swift)

class SymbolLayerZOrderExample_Swift: UIViewController, MGLMapViewDelegate {

var mapView: MGLMapView!
var symbolLayer: MGLSymbolStyleLayer?

override func viewDidLoad() {
    super.viewDidLoad()
    // Create a new map view using the Mapbox Light style.
    mapView = MGLMapView(frame: view.bounds)
    mapView.styleURL = MGLStyle.lightStyleURL
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.tintColor = .darkGray
    // Set the map’s center coordinate and zoom level.
    mapView.setCenter(CLLocationCoordinate2D(latitude: -41.25, longitude: 174.77), animated: false)
    mapView.zoomLevel = 11.5
    mapView.delegate = self
    view.addSubview(mapView)
}

// Wait until the style is loaded before modifying the map style.
func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Add icons to the map's style.
        // Note that adding icons to the map's style does not mean they have been added to the map yet.

        style.setImage(UIImage(named: "yellow-triangle-image")!, forName: "yellow-triangle")
        style.setImage(UIImage(named: "green-triangle-image")!, forName: "green-triangle")
        style.setImage(UIImage(named: "purple-triangle-image")!, forName: "purple-triangle")
    
        let purple = MGLPointFeature()
        purple.coordinate = CLLocationCoordinate2DMake(-41.24, 174.77)
        purple.attributes = ["id": "purple-triangle"]
    
        let green = MGLPointFeature()
        green.coordinate = CLLocationCoordinate2DMake(-41.25, 174.77)
        green.attributes = ["id": "green-triangle"]
    
        let yellow = MGLPointFeature()
        yellow.coordinate = CLLocationCoordinate2DMake(-41.26, 174.77)
        yellow.attributes = ["id": "yellow-triangle"]

        let shapeCollection = MGLShapeCollectionFeature(shapes: [yellow, green, purple])
        let source = MGLShapeSource(identifier: "symbol-layer-z-order-example", shape: shapeCollection, options: nil)
        style.addSource(source)
        let layer = MGLSymbolStyleLayer(identifier: "points-style", source: source)
        layer.sourceLayerIdentifier = "symbol-layer-z-order-example"

        // Create a stops dictionary with keys that are possible values for 'id', paired with icon images that will represent those features.
        let icons =
            ["yellow-triangle": "yellow-triangle",
             "green-triangle": "green-triangle",
             "purple-triangle": "purple-triangle"]
        // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
        layer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', id)", icons)

        layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        layer.symbolZOrder = NSExpression(forConstantValue: "source")
        style.addLayer(layer)

        self.symbolLayer = layer

        addToggleButton()
    }
    func addToggleButton() {
        // Create a UISegmentedControl to toggle between map styles
        let styleToggle = UISegmentedControl(items: ["viewport-y", "source"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.backgroundColor = UIColor(red: 0.83, green: 0.84, blue: 0.95, alpha: 1.0)
        styleToggle.tintColor = UIColor(red: 0.26, green: 0.39, blue: 0.98, alpha: 1.0)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
        styleToggle.selectedSegmentIndex = 1
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(toggleLayer(sender:)), for: .valueChanged)

        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mapView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }

    // Change the map style based on the selected index of the UISegmentedControl
    @objc func toggleLayer(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "viewport-y")
        case 1:
            self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "source")
        default:
            self.symbolLayer?.symbolZOrder = NSExpression(forConstantValue: "source")
        }
    }
}
