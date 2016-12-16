
import UIKit
import Mapbox

@objc(CameraFlyToExample_Swift)
class ViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the MGLMapView
        mapView = MGLMapView(frame: view.bounds)
        
        let honolulu = CLLocationCoordinate2D(latitude: 21.3069, longitude: -157.8583)
        mapView.setCenter(honolulu,
                          zoomLevel:14, animated: false)
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        // Waits for the mapView to finish loading before setting up the camera
        // Defines the destination camera as Hawaii Island
        let camera = MGLMapCamera(lookingAtCenter:
            CLLocationCoordinate2D(latitude: 19.784213, longitude: -155.784605),
                                  fromDistance: 35000, pitch: 70, heading: 90)
        
        // The mapView flyToCamera goes from the origin to destination camera. Set duration in seconds
        mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)
        
    }
}
