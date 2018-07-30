import Mapbox

@objc(ClusteringWithImagesExample_Swift)

class ClusteringWithImagesExample_Swift: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var polygonImage: UIImage!
    var starImage: UIImage!
    var rectangleImage: UIImage!
    var circleImage: UIImage!
    var popup: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Map
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.delegate = self
        view.addSubview(mapView)
        
        // Assign appropriate icon images
        polygonImage = UIImage(named: "polygon")
        starImage = UIImage(named: "star")
        rectangleImage = UIImage(named: "rectangle")
        circleImage = UIImage(named: "circle")
    }

//    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)
//
//    }

}
