//import Mapbox
//
//@objc(LocationPrivacyExample_Swift)
//
//class LocationPrivacyExample_Swift: UIViewController, MGLMapViewDelegate {
//    var mapView: MGLMapView?
//    var preciseButton: UIButton?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let mapView = MGLMapView(frame: view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.delegate = self
//        mapView.showsUserLocation = true
//        self.mapView = mapView
//
//        view.addSubview(mapView)
//    }
//
//    /**
//        In order to enable the alert that requests temporary precise location,
//        please add the following key to your info.plist
//        `NSLocationTemporaryUsageDescriptionDictionary`
//
//        You must then add
//        `MGLAccuracyAuthorizationDescription`
//        as a key in the Privacy - Location Temporary Usage Description Dictionary
//     */
//    @available(iOS 14, *)
//    func mapView(_ mapView: MGLMapView, didChangeLocationManagerAuthorization manager: MGLLocationManager) {
////        guard let accuracySetting = manager.accuracyAuthorization?() else { return }
//
//        if accuracySetting == .reducedAccuracy {
//            addPreciseButton()
//        } else {
//            removePreciseButton()
//        }
//    }
//
//    @available(iOS 14, *)
//    func addPreciseButton() {
//        let preciseButton = UIButton(frame: CGRect.zero)
//        preciseButton.setTitle("Turn Precise On", for: .normal)
//        preciseButton.backgroundColor = .gray
//
//        preciseButton.addTarget(self, action: #selector(requestTemporaryAuth), for: .touchDown)
//        self.view.addSubview(preciseButton)
//        self.preciseButton = preciseButton
//
//        // constraints
//        preciseButton.translatesAutoresizingMaskIntoConstraints = false
//        preciseButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
//        preciseButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
//        preciseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
//        preciseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    }
//
//    @available(iOS 14, *)
//    @objc private func requestTemporaryAuth() {
//        guard let mapView = self.mapView else { return }
//
//        let purposeKey = "MGLAccuracyAuthorizationDescription"
////        mapView.locationManager.requestTemporaryFullAccuracyAuthorization!(withPurposeKey: purposeKey)
//    }
//
//    private func removePreciseButton() {
//        guard let button = self.preciseButton else { return }
//        button.removeFromSuperview()
//        self.preciseButton = nil
//    }
//}
