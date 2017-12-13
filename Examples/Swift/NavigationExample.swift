import Foundation
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

@objc(NavigationExample_Swift)

class NavigationExample: UIViewController {
    
    override func viewDidLoad() {
        let origin = CLLocationCoordinate2DMake(37.77440680146262, -122.43539772352648)
        let destination = CLLocationCoordinate2DMake(37.76556957793795, -122.42409811526268)
        let options = NavigationRouteOptions(coordinates: [origin, destination])
        
        Directions.shared.calculate(options) { (waypoints, routes, error) in
            guard let route = routes?.first, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            let navigationController = NavigationViewController(for: route)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
