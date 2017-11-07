
import Mapbox

@objc(MapSnapshotterExample_Swift)

class MapSnapshotterExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Center map on the Giza Pyramid Complex in Egypt.
        let center = CLLocationCoordinate2D(latitude: 29.9773, longitude: 31.1325)
        let camera = MGLMapCamera(lookingAtCenter: center, fromDistance: 0, pitch: 0, heading: 0)
        
        let options = MGLMapSnapshotOptions(styleURL: MGLStyle.satelliteStreetsStyleURL(), camera: camera, size: view.bounds.size)
        options.zoomLevel = 14
        let snapshotter = MGLMapSnapshotter(options: options)
        
        snapshotter.start { (image, error) in
            if error != nil {
                print("Unable to create a map snapshot.")
            } else {
                guard let image = image else { return }
                let imageView = UIImageView(image: image)
                self.view.addSubview(imageView)
            }
        }
    }
    
    
}
