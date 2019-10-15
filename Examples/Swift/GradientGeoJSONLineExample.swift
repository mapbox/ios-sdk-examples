//
//  ViewController.swift
//  Gradient Line Exampe
//
//  Created by ZiZi Miles on 10/14/19.
//  Copyright © 2019 ZiZi Miles. All rights reserved.
//

import UIKit
import Mapbox
@objc(GradientGeoJSONLineExample_Swift)

class GradientGeoJSONLineExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.875, longitude: -77.035), zoomLevel: 12, animated: false)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        loadGeoJson()
    }
    func loadGeoJson() {
        DispatchQueue.global().async {
            // Get the path for example.geojson in the app’s bundle.
            guard let jsonUrl = Bundle.main.url(forResource: "iOSLineGeoJSON", withExtension: "geojson") else {
                preconditionFailure("Failed to load local GeoJSON file")
            }

            guard let jsonData = try? Data(contentsOf: jsonUrl) else {
                preconditionFailure("Failed to parse GeoJSON file")
            }
            DispatchQueue.main.async {
                self.drawPolyline(geoJson: jsonData)
            }
        }
    }
    func drawPolyline(geoJson: Data) {
    // Add our GeoJSON data to the map as an MGLGeoJSONSource.
    // We can then reference this data from an MGLStyleLayer.
    // MGLMapView.style is optional, so you must guard against it not being set.
    guard let style = self.mapView.style else { return }
    guard let shapeFromGeoJSON = try? MGLShape(data: geoJson, encoding: String.Encoding.utf8.rawValue) else {
    fatalError("Could not generate MGLShape")
    }
        let source = MGLShapeSource(identifier: "polyline", shape: shapeFromGeoJSON, options: [MGLShapeSourceOption.lineDistanceMetrics: true])
    style.addSource(source)
    // Create new layer for the line.
    let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
    // Set the line join and cap to a rounded end.
    layer.lineJoin = NSExpression(forConstantValue: "round")
    layer.lineCap = NSExpression(forConstantValue: "round")

        let stops =   [0: UIColor.blue,
                       0.1: UIColor.purple,
                       0.3: UIColor.cyan,
                       0.5: UIColor.green,
                       0.7: UIColor.yellow,
                       1: UIColor.red]

    // Set the line color to a constant blue color.
        layer.lineGradient = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($lineProgress, 'linear', nil, %@)", stops)

    // Use `NSExpression` to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
    layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                   [14: 10, 18: 20])

        style.addLayer(layer)
    }
}
