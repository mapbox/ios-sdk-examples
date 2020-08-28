//
//  POIAlongRoute.swift
//  Examples
//
//  Created by Takuto Suzuki on 2020/08/28.
//  Copyright © 2020 Mapbox. All rights reserved.
//

import Mapbox


@objc(POIAlongRouteExample_Swift)

class POIAlongRouteExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(
            CLLocationCoordinate2D(latitude: 45.52214, longitude: -122.63748),
            zoomLevel: 18,
            animated: false)
        view.addSubview(mapView)
        mapView.delegate = self
    }

    // Wait until the map is loaded before adding to the map.
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        loadGeoJson()
        restrictPOIVisibleShape()
        setCamera()
    }

    func loadGeoJson() {
        DispatchQueue.global().async {
            // Get the path for example.geojson in the app’s bundle.
            guard let jsonUrl = Bundle.main.url(forResource: "example", withExtension: "geojson") else {
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

    func setCamera() {
        let camera = mapView.camera
        camera.heading = 249.37706203842038
        camera.pitch = 60
        camera.centerCoordinate.latitude = 45.52199780570582
        camera.centerCoordinate.longitude = -122.6418837958432
        self.mapView.setCamera(camera, animated: false)
        self.mapView.setZoomLevel(15.062187320447523, animated: false)
    }

    func drawPolyline(geoJson: Data) {
        // Add our GeoJSON data to the map as an MGLGeoJSONSource.
        // We can then reference this data from an MGLStyleLayer.

        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView.style else { return }

        guard let shapeFromGeoJSON = try? MGLShape(data: geoJson, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }

        let source = MGLShapeSource(identifier: "polyline", shape: shapeFromGeoJSON, options: nil)
        style.addSource(source)

        // Create new layer for the line.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)

        // Set the line join and cap to a rounded end.
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")

        // Set the line color to a constant blue color.
        layer.lineColor = NSExpression(forConstantValue: UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1))

        // Use `NSExpression` to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 2, 18: 20])

        // We can also add a second layer that will draw a stroke around the original line.
        let casingLayer = MGLLineStyleLayer(identifier: "polyline-case", source: source)
        // Copy these attributes from the main line layer.
        casingLayer.lineJoin = layer.lineJoin
        casingLayer.lineCap = layer.lineCap
        // Line gap width represents the space before the outline begins, so should match the main line’s line width exactly.
        casingLayer.lineGapWidth = layer.lineWidth
        // Stroke color slightly darker than the line color.
        casingLayer.lineColor = NSExpression(forConstantValue: UIColor(red: 41/255, green: 145/255, blue: 171/255, alpha: 1))
        // Use `NSExpression` to gradually increase the stroke width between zoom levels 14 and 18.
        casingLayer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 1, 18: 4])

        // Just for fun, let’s add another copy of the line with a dash pattern.
        let dashedLayer = MGLLineStyleLayer(identifier: "polyline-dash", source: source)
        dashedLayer.lineJoin = layer.lineJoin
        dashedLayer.lineCap = layer.lineCap
        dashedLayer.lineColor = NSExpression(forConstantValue: UIColor.white)
        dashedLayer.lineOpacity = NSExpression(forConstantValue: 0.5)
        dashedLayer.lineWidth = layer.lineWidth
        // Dash pattern in the format [dash, gap, dash, gap, ...]. You’ll want to adjust these values based on the line cap style.
        dashedLayer.lineDashPattern = NSExpression(forConstantValue: [0, 1.5])

        guard let poiLayer = self.mapView.style?.layer(withIdentifier: "poi-label") as? MGLSymbolStyleLayer else {
            return
        }
        style.insertLayer(layer, below: poiLayer)
        style.insertLayer(dashedLayer, above: layer)
        style.insertLayer(casingLayer, below: layer)

    }

    func restrictPOIVisibleShape() {
        guard let poiLayer = self.mapView.style?.layer(withIdentifier: "poi-label") as? MGLSymbolStyleLayer else {
            return
        }
        guard let roadLabelLayer = self.mapView.style?.layer(withIdentifier: "road-label") as? MGLSymbolStyleLayer else {
            return
        }
        let polygonShape = [
            [-122.63730626171188,45.52288837762333 ],
            [ -122.65455070022612, 45.52299746891552 ],
            [ -122.65747018755947, 45.52177017968134 ],
            [ -122.65992255691913, 45.51931552089448 ],
            [ -122.66015611590598, 45.513696676587045 ],
            [ -122.66696825301655, 45.51375123117057 ],
            [ -122.6672018120034, 45.51222368283956 ],
            [ -122.6571977020749, 45.51225096085216 ],
            [ -122.6570419960839, 45.51822452705878 ],
            [ -122.65392787626189, 45.52106106703124 ],
            [ -122.63567134880579, 45.52114288817623 ],
            [ -122.63657745074761, 45.52288036393409 ],
            [ -122.6373404839605, 45.52291377640398 ]]
        let coordinates = polygonShape.map {CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
        let bufferedRoutePolygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count), interiorPolygons: nil)
        poiLayer.predicate = NSPredicate(format: "SELF IN %@", bufferedRoutePolygon)
        roadLabelLayer.predicate = NSPredicate(format: "SELF IN %@", bufferedRoutePolygon)
    }
}
