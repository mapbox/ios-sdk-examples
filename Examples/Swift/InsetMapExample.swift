import Mapbox

@objc(InsetMapExample_Swift)

class InsetMapExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var miniMapview: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        /** Set the delegate property of our map view to self after
        instantiating it.
        */
        mapView.delegate = self
        
        // Set the main map view's center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 18.1096,
                longitude: -77.2975), zoomLevel: 9, animated: false)
        
        // Set inset map View's center
        miniMapview = MGLMapView(frame: CGRect.zero)
        
        /**
         Set inset mapview properties to create a smaller,
         non-interactive map view that mimics the appearance of the main map view.
        */
        miniMapview.allowsScrolling = false
        miniMapview.allowsTilting = false
        miniMapview.allowsZooming = false
        miniMapview.allowsRotating = false
        miniMapview.compassView.isHidden = true

        /**
         Hiding the map view's attribution goes against our attribution requirements.
         However, because the main map view still has attribution, hiding the
         attribution for the mini map view in this case is acceptable.

         For more information, please refer to our attribution guidelines:
         https://docs.mapbox.com/help/how-mapbox-works/attribution/
        */
        miniMapview.logoView.isHidden = true
        miniMapview.attributionButton.tintColor = UIColor.clear
        miniMapview.layer.borderColor = UIColor.black.cgColor
        miniMapview.layer.borderWidth = 1
        
        /**
         Setting mini map view zoom level to 2 zoom levels below the main map view to showcase
         one use case for an inset map.
        */
        miniMapview.setCenter(self.mapView.centerCoordinate,
                              zoomLevel: mapView.zoomLevel - 2, animated: false)
        miniMapview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(miniMapview)
        
        installConstraints()
    }
    
    /**
     Set the mini map view's camera to the map view camera so while
     the region is changing on the map view, the same camera changes
     are made in the mini map view.
     */
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
         miniMapview.setCenter(self.mapView.centerCoordinate,
         zoomLevel: mapView.zoomLevel - 2, animated: false)
     }

    
    func installConstraints() {
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                miniMapview.bottomAnchor.constraint(equalTo:
                    safeArea.bottomAnchor, constant: -40),
                miniMapview.trailingAnchor.constraint(equalTo:
                    safeArea.trailingAnchor, constant: -15),
                miniMapview.widthAnchor.constraint(equalTo:
                    safeArea.widthAnchor, multiplier: 0.33),
                miniMapview.heightAnchor.constraint(equalTo:
                    miniMapview.widthAnchor)
            ])
        } else {
            miniMapview.autoresizingMask = [.flexibleTopMargin,
                                            .flexibleLeftMargin,
                                            .flexibleRightMargin]
        }
    }
}
