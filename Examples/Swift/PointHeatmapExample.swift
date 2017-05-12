
import Mapbox

@objc(PointHeatmapExample_Swift)

class PointHeatmapExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Parse GeoJSON data from USGS on earthquakes in the past week.
        DispatchQueue.global().async {
            guard let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson") else { return }
            DispatchQueue.main.async {
                self.displayEarthquakes(url: url, style: style)
            }
        }
    }
    
    func displayEarthquakes(url: URL, style: MGLStyle) {
        let symbolSource = MGLSource(identifier: "symbol-source")
        let symbolLayer = MGLSymbolStyleLayer(identifier: "place-city-sm", source: symbolSource)
        
        // Set the MGLShapeSourceOptions to allow clustering.
        let options = [MGLShapeSourceOption.clustered: true,
                       MGLShapeSourceOption.clusterRadius: 20,
                       MGLShapeSourceOption.maximumZoomLevel: 15] as [MGLShapeSourceOption : Any]
        
        let earthquakeSource = MGLShapeSource(identifier: "earthquakes", url: url, options: options)
        style.addSource(earthquakeSource)
        
        // Create a stops dictionary. The keys represent the number of points in a cluster.
        let stops = [
            0.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)),
            20.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 249/255.0, green: 136/255.0, blue: 108/255.0, alpha: 1)),
            150.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1))
        ]
        
        let clusteredLayer = MGLCircleStyleLayer(identifier: "clustered layer", source: earthquakeSource)
        clusteredLayer.circleColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "point_count", options: [.defaultValue: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1))])
        clusteredLayer.circleRadius = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 70))
        clusteredLayer.circleBlur = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 1))
        
        style.insertLayer(clusteredLayer, below: symbolLayer)
    }
}
