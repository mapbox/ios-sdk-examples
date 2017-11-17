import Mapbox

@objc(MapSnapshotterExample_Swift)

class MapSnapshotterExample: UIViewController, MGLMapViewDelegate {

    var mapView : MGLMapView!
    var button : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStreetsStyleURL())
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Center map on the Giza Pyramid Complex in Egypt.
        let center = CLLocationCoordinate2D(latitude: 29.9773, longitude: 31.1325)
        mapView.setCenter(center, zoomLevel: 14, animated: false)
        view.addSubview(mapView)

        // Create a button to take a map snapshot.
        button = UIButton(frame: CGRect(x: view.bounds.width / 2 - 15, y: view.bounds.height - 80, width: 30, height: 30))
        button.layer.cornerRadius = 15
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.addTarget(self, action: #selector(createSnapshot), for: .allTouchEvents)
        view.addSubview(button)
    }
    
    @objc func createSnapshot() {
        
        // Create a UIImageView that will store the map snapshot.
        let imageView = UIImageView(frame: view.bounds)
        imageView.backgroundColor = .black
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Use the map's style, camera, size, and zoom level to set the snapshot's options.
        let options = MGLMapSnapshotOptions(styleURL: mapView.styleURL, camera: mapView.camera, size: mapView.bounds.size)
        options.zoomLevel = mapView.zoomLevel
        
        // Create the map snapshot.
        let snapshotter = MGLMapSnapshotter(options: options)
        
        snapshotter.start { (snapshot, error) in
            if error != nil {
                print("Unable to create a map snapshot.")
            } else if let snapshot = snapshot {
                imageView.image = snapshot.image
                self.view.addSubview(imageView)
            }
        }
    }
}
