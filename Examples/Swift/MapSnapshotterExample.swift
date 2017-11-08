
import Mapbox

@objc(MapSnapshotterExample_Swift)

class MapSnapshotterExample: UIViewController, MGLMapViewDelegate {
    var mapView : MGLMapView!
    var snapshotView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2), styleURL: MGLStyle.satelliteStreetsStyleURL())
        
        // Center map on the Giza Pyramid Complex in Egypt.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 29.9757, longitude: 31.1308), zoomLevel: 14, animated: false)
        mapView.tintColor = .darkGray
        
        // Set the map view‘s delegate property.
        mapView.delegate = self
        view.addSubview(mapView)
        
        snapshotView = UIView(frame: CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
        snapshotView.backgroundColor = .darkGray
        view.addSubview(snapshotView)
        
        if #available(iOS 11.0, *) {
            let drag = UIDragInteraction(delegate: self)
            mapView.addInteraction(drag)
        } else {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addSnapshot(_:)))
            swipe.direction = .down
            mapView.addGestureRecognizer(swipe)
        }
    }
    
    func createMapSnapshot() -> UIImage {
        let center = mapView.centerCoordinate
        let camera = mapView.camera
        
        let options = MGLMapSnapshotOptions(styleURL: MGLStyle.satelliteStreetsStyleURL(), camera: camera, size: view.bounds.size)
        options.zoomLevel = 14
        let snapshotter = MGLMapSnapshotter(options: options)
        var snapshot = UIImage()
        snapshotter.start { (image, error) in
            if error != nil {
                print("Unable to create a map snapshot.")
            } else {
                guard let image = image else { return }
                snapshot = image
            }
        }
        return snapshot
    }
    
    @objc func addSnapshot(_ sender: UISwipeGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        
        let image = createMapSnapshot()
    }
}

@available(iOS 11.0, *)
extension MapSnapshotterExample : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let image = createMapSnapshot()
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        
        return [item]
    }
}
