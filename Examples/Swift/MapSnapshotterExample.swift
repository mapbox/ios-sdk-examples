import Mapbox

@objc(MapSnapshotterExample_Swift)

class MapSnapshotterExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a UIImageView that will store the map snapshot.
        let imageView = UIImageView(frame: view.bounds)
        imageView.backgroundColor = .black
        view.addSubview(imageView)
        
        // Center map on the Giza Pyramid Complex in Egypt.
        let center = CLLocationCoordinate2D(latitude: 29.9773, longitude: 31.1325)
        let camera = MGLMapCamera(lookingAtCenter: center, fromDistance: 0, pitch: 0, heading: 0)
        
        // Set the snapshot object's style, camera, size, and zoom level.
        let options = MGLMapSnapshotOptions(styleURL: MGLStyle.satelliteStreetsStyleURL(), camera: camera, size: view.bounds.size)
        options.zoomLevel = 14
        
        // Create the map snapshot.
        let snapshotter = MGLMapSnapshotter(options: options)
        
        snapshotter.start { (snapshot, error) in
            if error != nil {
                print("Unable to create a map snapshot.")
            } else {
                guard let snapshot = snapshot else { return }
                
                imageView.image = snapshot.image
            }
        }
    }
}
