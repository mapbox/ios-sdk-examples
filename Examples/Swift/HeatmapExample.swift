
import Mapbox

@objc(HeatmapExample_Swift)

class HeatmapExample: UIViewController, MGLMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create and add a map view.
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.darkStyleURL)
        mapView.delegate = self
        mapView.tintColor = .lightGray
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Parse GeoJSON data. This example uses all M1.0+ earthquakes from 12/22/15 to 1/21/16 as logged by USGS' Earthquake hazards program.
        guard let url = URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson") else { return }
        let source = MGLShapeSource(identifier: "earthquakes", url: url, options: nil)
        style.addSource(source)
        
        // Create a heatmap layer.
        let layer = MGLHeatmapStyleLayer(identifier: "earthquakes", source: source)
        
        // Create a stops.
        let colorDictionary : [NSNumber : UIColor] = [
                                0.0 :  .clear,
                               0.01 : .white,
                               0.15 : UIColor(red:0.19, green:0.30, blue:0.80, alpha:1.0),
                               0.5 : UIColor(red:0.73, green:0.23, blue:0.25, alpha:1.0),
                               1 : .yellow
        ]
//        layer.heatmapColor = NSExpression.mgl_expression(forInterpolateFunction: .heatmapDensity, curveType: .linear, steps: colorDictionary)
//        layer.heatmapIntensity = NSExpression.mgl_expression(forInterpolateFunction: .zoomLevel, curveType: .linear, steps: [0: 1, 9:3])
//        layer.heatmapRadius = NSExpression.mgl_expression(forInterpolateFunction: .zoomLevel, curveType: .linear, steps: [0: 4, 9: 30])
//
//        layer.heatmapWeight = NSExpression.mgl_expression(forInterpolateFunction: NSExpression(forKeyPath: "mag"),
//                                                          curveType: .linear,
//                                                          parameters: nil,
//                                                          steps: NSExpression(forConstantValue:  [0: 0, 6: 1]))
//        layer.heatmapOpacity = NSExpression.mgl_expression(forStepFunction: .zoomLevel, defaultValue: 0.75 as NSValue, stops: [9: 0])
        
        layer.heatmapColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)", colorDictionary)
        layer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                              [0: 1,
                                               9: 3])
        layer.heatmapRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                           [0: 4,
                                            9: 30])
        
        layer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)",
                                           [0: 0,
                                            6: 1])
        layer.heatmapOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, %d, %@)", 0.75, [0: 0.75, 9: 0])
        
        style.addLayer(layer)
        
        let magnitudeDictionary : [NSNumber : UIColor] = [0 : .white,
                                                        0.5 : .yellow,
                                                        2.5 : UIColor(red:0.73, green:0.23, blue:0.25, alpha:1.0),
                                                        5 : UIColor(red:0.19, green:0.30, blue:0.80, alpha:1.0)
                                                        ]
        let circleLayer = MGLCircleStyleLayer(identifier: "circle-layer", source: source)
        circleLayer.circleColor = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(mag, 'linear', nil, %@)", magnitudeDictionary)
        circleLayer.circleOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, %d, %@)", 0, [0: 0, 9: 0.75])
        circleLayer.circleRadius = NSExpression(forConstantValue: 20)
        circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
        circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 6)
        circleLayer.circleStrokeOpacity = NSExpression(format: "mgl_step:from:stops:($zoomLevel, %d, %@)", 0, [0: 0, 9: 0.75])
        style.addLayer(circleLayer)
    }
}
