import UIKit
import Mapbox

@objc(ChangeWorldviewBoundariesExample_Swift)

class ChangeWorldviewBoundariesExample: UIViewController, MGLMapViewDelegate {

    let mapView = MGLMapView()
    let source = MGLVectorTileSource(identifier: "admin-bounds", configurationURL: NSURL(string: "mapbox://mapbox.mapbox-streets-v8")! as URL)
    var adminLayers = [String]()
    var layer: MGLLineStyleLayer?
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map's initial style, center coordinate, and zoom level
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.setCenter(CLLocationCoordinate2D(latitude: 25.251, longitude: 95.69), zoomLevel: 3, animated: false)

        view.addSubview(mapView)

        // Create a UISegmentedControl to toggle between map styles
        let styleToggle = UISegmentedControl(items: ["  US  ", "  CN  ", "  IN  ","  All  "])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
        styleToggle.backgroundColor = UIColor(red: 184/255, green: 205/255, blue: 212/255, alpha: 1)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
//        styleToggle.selectedSegmentIndex = 0
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(changeStyle(sender:)), for: .valueChanged)

        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])

    }

    // Change the map style based on the selected index of the UISegmentedControl
    @objc func changeStyle(sender: UISegmentedControl) {

        guard let style = self.mapView.style else {return}

        if layer?.identifier == "admin" {
            print("source already exists")
            style.removeLayer(layer!)
        } else {
            layer = MGLLineStyleLayer(identifier: "admin", source: source)
            style.addSource(source)
        }
        layer?.sourceLayerIdentifier = "admin"
        layer?.lineColor = NSExpression(forConstantValue: UIColor.lightGray)

        switch sender.selectedSegmentIndex {
        case 0:

           layer?.predicate = NSPredicate(format: "CAST(worldview, 'NSString') == 'US'")
           style.addLayer(layer!)
        case 1:
            layer?.predicate = NSPredicate(format: "CAST(worldview, 'NSString') == 'CN'")
            style.addLayer(layer!)
        case 2:
            layer?.predicate = NSPredicate(format: "CAST(worldview, 'NSString') == 'IN'")
            style.addLayer(layer!)
        case 3:
            layer?.predicate = NSPredicate(format: "CAST(worldview, 'NSString') == 'all'")
            style.addLayer(layer!)
        default:
            style.addLayer(layer!)

        }
    }
}
