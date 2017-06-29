
import Mapbox

@objc(PointHotspotExample_Swift)

class PointHotspotExample_Swift: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Parse GeoJSON data. This example uses all M1.0+ earthquakes from 12/22/15 to 1/21/16 as logged by USGS' Earthquake hazards program.
        guard let url = URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson") else { return }
        
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
            0.0: MGLStyleValue<UIColor>(rawValue: .yellow),
            20.0: MGLStyleValue<UIColor>(rawValue: .orange),
            150.0: MGLStyleValue<UIColor>(rawValue: .red)
        ]
        
        // Create and style the clustered circle layer.
        let clusteredLayer = MGLCircleStyleLayer(identifier: "clustered layer", source: earthquakeSource)
        clusteredLayer.circleColor = MGLStyleValue(interpolationMode: .exponential, sourceStops: stops, attributeName: "point_count", options: [.defaultValue: MGLStyleValue<UIColor>(rawValue: .yellow)])
        clusteredLayer.circleRadius = MGLConstantStyleValue(rawValue: NSNumber(integerLiteral: 70))
        clusteredLayer.circleOpacity = MGLConstantStyleValue(rawValue: 0.5)
        clusteredLayer.circleBlur = MGLConstantStyleValue(rawValue: 1)
        
        style.insertLayer(clusteredLayer, below: symbolLayer)
    }
}
