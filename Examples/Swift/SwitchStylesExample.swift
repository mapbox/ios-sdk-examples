import UIKit
import Mapbox

@objc(SwitchStylesExample_Swift)

class SwitchStylesExample: UIViewController {

    let mapView = MGLMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map's initial style, center coordinate, and zoom level
        mapView.styleURL = MGLStyle.streetsStyleURL
        mapView.setCenter(CLLocationCoordinate2D(latitude: 28.10, longitude: -81.76), zoomLevel: 5.4, animated: false)
        view.addSubview(mapView)

        // Create a UISegmentedControl to toggle between map styles
        let styleToggle = UISegmentedControl(items: ["Satellite", "Streets", "Light"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
        styleToggle.backgroundColor = UIColor(red: 0.973, green: 0.329, blue: 0.294, alpha: 1)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
        styleToggle.selectedSegmentIndex = 1
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(changeStyle(sender:)), for: .valueChanged)

        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }

    // Change the map style based on the selected index of the UISegmentedControl
    @objc func changeStyle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.styleURL = MGLStyle.satelliteStyleURL
        case 1:
            mapView.styleURL = MGLStyle.streetsStyleURL
        case 2:
            mapView.styleURL = MGLStyle.lightStyleURL
        default:
            mapView.styleURL = MGLStyle.streetsStyleURL
        }
    }
}
