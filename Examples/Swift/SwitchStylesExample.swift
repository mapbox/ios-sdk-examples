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
        let styleToggle = UISegmentedControl(items: ["Dark", "Streets", "Light"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.selectedSegmentIndex = 1
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(changeStyle(sender:)), for: .valueChanged)
        
        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[styleToggle]-40-|", options: [], metrics: nil, views: ["styleToggle" : styleToggle]))
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }
    
    // Change the map style based on the selected index of the UISegmentedControl
    @objc func changeStyle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.styleURL = MGLStyle.darkStyleURL
        case 1:
            mapView.styleURL = MGLStyle.streetsStyleURL
        case 2:
            mapView.styleURL = MGLStyle.lightStyleURL
        default:
            mapView.styleURL = MGLStyle.streetsStyleURL
        }
    }
}

