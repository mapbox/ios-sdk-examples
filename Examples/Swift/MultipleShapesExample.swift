import Mapbox

@objc(MultipleShapesExample_Swift)

class MultipleShapesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure a map view centered on Washington, D.C. 
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.897435, longitude: -77.039679), zoomLevel: 12, animated: false)
        mapView.delegate = self

        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        // Since we know this file exists within this project, we'll force unwrap its value.
        // If this data was coming from an external server, we would want to perform
        // proper error handling for a web request/response.
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "dc-metro", ofType: "geojson")!)

        // Create a shape source and register it with the map style.
        let source = MGLShapeSource(identifier: "transit", url: url, options: nil)
        style.addSource(source)

        // Add different line, point, and polygon shapes to the map style.
        style.addLines(from: source)
        style.addPoints(from: source)
        style.addPolygons(from: source)
    }
}

extension MGLStyle {
    func addLines(from source: MGLShapeSource) {
        /**
         Configure a line style layer to represent a rail line, filtering out all data from the
         source that is not of `Rail line` type. The `TYPE` is an attribute of the source data
         that can be seen by inspecting the GeoJSON source file, for example:

        {
          "type": "Feature",
          "properties": {
            "NAME": "Dupont Circle",
            "TYPE": "metro-station"
          },
          "geometry": {
            "type": "Point",
            "coordinates": [
              -77.043416,
              38.909605
            ]
          },
          "id": "994446c244acadeb15d3f9fc18278c73"
        }
        */
        let lineLayer = MGLLineStyleLayer(identifier: "rail-line", source: source)
        lineLayer.predicate = NSPredicate(format: "TYPE = 'Rail line'")
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.red)
        lineLayer.lineWidth = NSExpression(forConstantValue: 2)

        self.addLayer(lineLayer)
    }

    func addPoints(from source: MGLShapeSource) {
        // Configure a circle style layer to represent rail stations, filtering out all data from
        // the source that is not of `metro-station` type.
        let circleLayer = MGLCircleStyleLayer(identifier: "stations", source: source)
        circleLayer.predicate = NSPredicate(format: "TYPE = 'metro-station'")
        circleLayer.circleColor = NSExpression(forConstantValue: UIColor.red)
        circleLayer.circleRadius = NSExpression(forConstantValue: 6)
        circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.black)

        self.addLayer(circleLayer)
    }

    func addPolygons(from source: MGLShapeSource) {
        // Configure a fill style layer to represent polygon regions in Washington, D.C.
        // Source data that is not of `neighborhood-region` type will be excluded.
        let polygonLayer = MGLFillStyleLayer(identifier: "DC-regions", source: source)
        polygonLayer.predicate = NSPredicate(format: "TYPE = 'neighborhood-region'")
        polygonLayer.fillColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 0.3))
        polygonLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 0.27, green: 0.41, blue: 0.97, alpha: 1.0))

        self.addLayer(polygonLayer)
    }
}
