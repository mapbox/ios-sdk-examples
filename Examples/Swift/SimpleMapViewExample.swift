import Mapbox
import MapboxMobileEvents

@objc(SimpleMapViewExample_Swift)

class SimpleMapViewExample_Swift: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }
}

extension SimpleMapViewExample_Swift: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let eventsManager = MMEEventsManager.shared()
        eventsManager.initialize(
            withAccessToken: "pk.eyJ1Ijoic3ZjLW9rdGEtbWFwYm94LXN0YWZmLWFjY2VzcyIsImEiOiJjazZjbG9ucGIxOGV1M2tvN2Fyb2c0dTU1In0.nTI6qRoxXoGHWaTOdCyyYw",
            userAgentBase: "user-agent-string",
            hostSDKVersion: "1.0.0")
        eventsManager.sendTurnstileEvent()
        eventsManager.delegate = self;
        
        let attributes = ["sessionIdentifier": "test1",
                          "event": "adMetrics.select",
                          "adid": "adid-test1",
                          "created": "2020-05-14T02:20:40.127Z",
            ] as [String : Any]
        eventsManager.enqueueEvent(withName: "adMetrics.select", attributes: attributes )
        eventsManager.flush()
    }
}

extension SimpleMapViewExample_Swift: MMEEventsManagerDelegate {
    func eventsManager(_ eventsManager: MMEEventsManager, didEncounterError error: Error) {
        
    }
    
    func eventsManager(_ eventsManager: MMEEventsManager, didVisit visit: CLVisit) {
        
    }
}
