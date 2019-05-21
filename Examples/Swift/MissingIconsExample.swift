import UIKit
import Mapbox

@objc(MissingIconsExample_Swift)

class MissingIconsExample: UIViewController {

    let mapView = MGLMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: This is a test case, it should be changed to fulfill an ios example spec.
        mapView.styleURL = MGLStyle.streetsStyleURL
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.delegate = self
        view.addSubview(mapView)

        // Create a button to load the faulty style.
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.white
        button.setTitle("Load faulty style", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(loadFaultyStyle(sender:)), for: .touchUpInside)
        view.addSubview(button)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                         button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20)])
        } else {
            // This code should be enabled once we require iOS 9.0 as minimum target.
//            NSLayoutConstraint.activate([button.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
//                                         button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)])
        }
    }

    @objc func loadFaultyStyle(sender: Any?) {
        let customStyleJSON = Bundle.main.url(forResource: "missing_icon", withExtension: "json")
        mapView.styleURL = customStyleJSON
    }

}

extension MissingIconsExample: MGLMapViewDelegate {

    func mapView(_ mapView: MGLMapView, didFailToLoadImage imageName: String) -> UIImage? {

        if (!(imageName == "skip-this-missing-icon")) {
            let backupImage = UIImage(named: "mapbox")
            return backupImage
        }
        return nil
    }

}
