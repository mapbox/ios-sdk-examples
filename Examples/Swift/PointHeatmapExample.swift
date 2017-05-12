
import Mapbox

@objc(PointHeatmapExample_Swift)

class PointHeatmapExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
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
        
        //
        let options = [MGLShapeSourceOption.clustered: true,
                       MGLShapeSourceOption.clusterRadius: 20,
                       MGLShapeSourceOption.maximumZoomLevel: 15] as [MGLShapeSourceOption : Any]
        
        let earthquakeSource = MGLShapeSource(identifier: "earthquakes", url: url, options: options)
        style.addSource(earthquakeSource)
        
        let unclusteredLayer = MGLCircleStyleLayer(identifier: "unclustered", source: earthquakeSource)
        
        unclusteredLayer.circleColor = MGLConstantStyleValue(rawValue: UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1))
        unclusteredLayer.circleRadius = MGLConstantStyleValue(rawValue: 20)
        unclusteredLayer.circleBlur = MGLConstantStyleValue(rawValue: 15)
        unclusteredLayer.predicate = NSPredicate(format: "%K != YES", argumentArray: ["cluster"])
        style.insertLayer(unclusteredLayer, below: symbolLayer)
        
        let stops = [
            0.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)),
            20.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 249/255.0, green: 136/255.0, blue: 108/255.0, alpha: 1)),
            150.0: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1))
        ]
        
        let circles = MGLCircleStyleLayer(identifier: "clustered layer", source: earthquakeSource)
        circles.circleColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "point_count", options: [.defaultValue: MGLStyleValue(rawValue: UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1))])
        circles.circleRadius = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 70))
        circles.circleBlur = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 1))
        
        style.insertLayer(circles, below: symbolLayer)
    }
}
