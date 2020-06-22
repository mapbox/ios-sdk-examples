import Mapbox

@objc(InsetMapExample_Swift)

class InsetMapExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var miniMapview: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // Set the main map's center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 18.1096, longitude: -77.2975), zoomLevel: 9, animated: false)

        // Set inset mapView's center
        miniMapview = MGLMapView(frame: CGRect.zero)
        
        // Set inset mapview properties to create a smaller, non-interactive mapView that mimics the appearance of the main mapView.
        miniMapview.allowsScrolling = false
        miniMapview.allowsTilting = false
        miniMapview.allowsZooming = false
        miniMapview.allowsRotating = false
        miniMapview.compassView.isHidden = true
        
        // we are only hiding the attribution within the second map view. Ordinarily, hiding the map view's attribution would be a violation of TOS, however, because the main map view still has its attribution, there is no issue here.
        miniMapview.logoView.isHidden = true
        miniMapview.attributionButton.tintColor = UIColor.clear
        miniMapview.layer.borderColor = UIColor.black.cgColor
        miniMapview.layer.borderWidth = 1
        miniMapview.setCenter(self.mapView.centerCoordinate, zoomLevel: mapView.zoomLevel, animated: false)
        miniMapview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(miniMapview)
        
        installConstraints()
    }
    
    // Set the miniMapView's camera to the mapView camera so that while the region is changing on the mapView, the same camera changes are made in the miniMapview.
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        miniMapview.setCamera(mapView.camera, animated: false)
    }
    
    func installConstraints() {
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                miniMapview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),
                miniMapview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
                miniMapview.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.33),
                miniMapview.heightAnchor.constraint(equalTo: miniMapview.widthAnchor)
            ])
        } else {
            miniMapview.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        }
    }
}
