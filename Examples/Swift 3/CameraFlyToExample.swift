
import UIKit
import Mapbox

@objc(CameraFlyToExample_Swift)
class ViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the MGLMapView
        mapView = MGLMapView(frame: view.bounds)
        
        // Centers the mapView on Honololu
        mapView.setCenter(CLLocationCoordinate2D(latitude: 21.3069, longitude: -157.8583),
                          zoomLevel:14, animated: false)
        
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        // Waits for the mapView to finish loading before setting up the camera
        // Defines the destination camera as Hawaii Island
        let camera = MGLMapCamera(lookingAtCenter:
                            CLLocationCoordinate2D(latitude: 19.503148, longitude: -155.489776),
                            fromDistance: 270000, pitch: 10, heading: 10)
        
        // The mapView flyToCamera goes from the origin to destination camera. Set duration in seconds
        mapView.fly(to: camera, withDuration: 4, peakAltitude: 450000, completionHandler: {
            print("We've arrived!")
        })
        
    }
    
}
