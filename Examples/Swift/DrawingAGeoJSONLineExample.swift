import Mapbox

@objc(DrawingAGeoJSONLineExample_Swift)

class DrawingAGeoJSONLineExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736),
                          zoomLevel: 11, animated: false)
        view.addSubview(self.mapView)
        
        mapView.delegate = self
        
        drawPolyline()
    }
    
    func drawPolyline() {
        // Parsing GeoJSON can be CPU intensive, do it on a background thread
        
        DispatchQueue.global(qos: .background).async(execute: {
            // Get the path for example.geojson in the app's bundle
            let jsonPath = Bundle.main.path(forResource: "example", ofType: "geojson")
            let url = URL(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data(contentsOf: url)
                // Load and serialize the GeoJSON into a dictionary filled with properly-typed objects
                if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : AnyObject] {
                    
                    // Load the `features` array for iteration
                    if let features = jsonDict["features"] as? NSArray {
                        for feature in features {
                            if let feature = feature as? NSDictionary {
                                if let geometry = feature["geometry"] as? NSDictionary {
                                    if geometry["type"] as? String == "LineString" {
                                        // Create an array to hold the formatted coordinates for our line
                                        var coordinates: [CLLocationCoordinate2D] = []
                                        
                                        if let locations = geometry["coordinates"] as? [[Double]] {
                                            // Iterate over line coordinates, stored in GeoJSON as many lng, lat arrays
                                            for location in locations {
                                                // Make a CLLocationCoordinate2D with the lat, lng
                                                let coordinate = CLLocationCoordinate2D(latitude: location[1], longitude: location[0])
                                                
                                                // Add coordinate to coordinates array
                                                coordinates.append(coordinate)
                                            }
                                        }
                                        
                                        let line = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
                                        
                                        // Optionally set the title of the polyline, which can be used for:
                                        //  - Callout view
                                        //  - Object identification
                                        line.title = "Crema to Council Crest"
                                        
                                        // Add the annotation on the main thread
                                        
                                        DispatchQueue.main.async(execute: {
                                            // Unowned reference to self to prevent retain cycle
                                            [unowned self] in
                                            self.mapView.addAnnotation(line)
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                print("GeoJSON parsing failed")
            }
            
        })
        
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        // Set the alpha for all shape annotations to 1 (full opacity)
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 2.0
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        if (annotation.title == "Crema to Council Crest" && annotation is MGLPolyline) {
            // Mapbox cyan
            return UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1)
        }
        else
        {
            return .red
        }
    }
}
