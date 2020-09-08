import Mapbox

@objc(LocationPrivacyExample_Swift)

class LocationPrivacyExample_Swift: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.userTrackingMode = .follow

        view.addSubview(mapView)
    }

    /**
        In order to enable the alert that requests temporary precise location, please add the following key to your info.plist
        Privacy - Location Temporary Usage Description Dictionary

        You must then add MGLAccuracyAuthorizationDescription as key in the Privacy - Location Temporary Usage Description Dictionary
     */
    @available(iOS 14, *)
    func mapView(_ mapView: MGLMapView, didChangeLocationManagerAuthorization manager: MGLLocationManager) {
        guard let accuracySetting = manager.accuracyAuthorization?() else { return }

        if accuracySetting == .reducedAccuracy {
            let alert = UIAlertController(title: "Examples will work best with your precise location",
                                          message: "Please enable in settings to not receive this message again",
                                          preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Turn On In Settings",
                                               style: .default,
                                               handler: { _ in
                                                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                                               })
            let defaultAction = UIAlertAction(title: "Keep Precise Location Off",
                                               style: .default,
                                               handler: nil)

            alert.addAction(settingsAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
