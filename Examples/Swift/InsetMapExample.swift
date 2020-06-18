import Mapbox

@objc(InsetMapExample_Swift)

class InsetMapExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView = MGLMapView()
    var miniMapview = MGLMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // Set the main map's center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)

        // set inset mapview properties
        miniMapview.allowsScrolling = false
        miniMapview.allowsTilting = false
        miniMapview.allowsZooming = false
        miniMapview.allowsRotating = false
        miniMapview.compassView.isHidden = true
        miniMapview.logoView.isHidden = true
        miniMapview.attributionButton.tintColor = UIColor.clear
        let black = UIColor.black
        miniMapview.layer.borderColor = black.cgColor
        miniMapview.layer.borderWidth = 1
        
        // set inset mapview's cen
        miniMapview.setCenter(mapView.centerCoordinate, zoomLevel: mapView.zoomLevel, animated: true)
        miniMapview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        mapView.addSubview(miniMapview)
        installConstraints()
       
    }
 
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        miniMapview.setCamera(mapView.camera, animated: false)
    }
    
    func installConstraints() {
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                miniMapview.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -35),
                miniMapview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                miniMapview.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.33),
                miniMapview.heightAnchor.constraint(equalTo: miniMapview.widthAnchor)
            ])
        } else {
            miniMapview.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        }
    }
}
