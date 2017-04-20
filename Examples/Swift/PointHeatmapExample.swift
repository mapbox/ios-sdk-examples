
import Mapbox

@objc(PointHeatmapExample_Swift)

class PointHeatmapExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let mapView : MGLMapView = MGLMapView(frame: view.bounds)
        
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let source = MGLSource(identifier: "source")
        
        let symbolLayer = MGLSymbolStyleLayer(identifier: "place-city-sm", source: source)
        let url = URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson")!
        let options = [MGLShapeSourceOption.clustered : true,
                       MGLShapeSourceOption.clusterRadius : 20,
                       MGLShapeSourceOption.maximumZoomLevel : 15] as [MGLShapeSourceOption : Any]
        
        let geoJSONSource = MGLShapeSource(identifier: "earthquakes", url: url, options: options)
        style.addSource(geoJSONSource)
        
        let unclusteredLayer = MGLCircleStyleLayer(identifier: "unclustered", source: geoJSONSource)
        
        unclusteredLayer.circleColor = MGLConstantStyleValue(rawValue: UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1))
        unclusteredLayer.circleRadius = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 20))
        unclusteredLayer.circleBlur = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 15))
        unclusteredLayer.predicate = NSPredicate(format: "%K != YES", argumentArray: ["cluster"])
//        style.insertLayer(unclusteredLayer, below: symbolLayer)
        
        let stops = [
                    NSNumber(floatLiteral: 0.0): MGLStyleValue(rawValue: UIColor(colorLiteralRed: 251/255.0, green: 176/255.0, blue: 59/255.0, alpha: 1)),
                    NSNumber(floatLiteral: 20.0): MGLStyleValue(rawValue: UIColor(colorLiteralRed: 249/255.0, green: 136/255.0, blue: 108/255.0, alpha: 1)),
                    NSNumber(floatLiteral: 150.0): MGLStyleValue(rawValue: UIColor(colorLiteralRed: 229/255.0, green: 94/255.0, blue: 94/255.0, alpha: 1))
                     ]
        
        let circles = MGLCircleStyleLayer(identifier: "cluster", source: geoJSONSource)
        circles.circleColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "point_count", options: nil)
        circles.circleRadius = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 70))
        circles.circleBlur = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 1))
        
        //            let gtePredicate = NSPredicate(format: "%K >= %@", argumentArray: ["point_count", layers[index][0] as! NSNumber])
        //            let allPredicate = index == 0 ?
        //                gtePredicate :
        //                NSCompoundPredicate(andPredicateWithSubpredicates: [gtePredicate, NSPredicate(format: "%K < %@", argumentArray: ["point_count", layers[index - 1][0] as! NSNumber])])
        
        //            circles.predicate = allPredicate
        
        style.insertLayer(circles, below: symbolLayer)
    }
}


