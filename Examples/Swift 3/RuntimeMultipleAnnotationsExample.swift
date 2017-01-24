//
//  RuntimeMultipleAnnotationsExample.swift
//  Examples
//
//  Created by Eric Wolfe on 12/2/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

#if swift(>=3.0)
import Mapbox

@objc(RuntimeMultipleAnnotationsExample_Swift)

class RuntimeMultipleAnnotationsExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.090240, longitude: -95.712891), zoomLevel: 2, animated: false)

        mapView.delegate = self

        view.addSubview(mapView)

        // Add our own gesture recognizer to handle taps on our custom map features.
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RuntimeMultipleAnnotationsExample_Swift.handleMapTap(sender:))))
        
        self.mapView = mapView
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.fetchPoints(withCompletion: { (features) in
            self.addItemsToMap(features: features)
        })
    }

    func addItemsToMap(features: [MGLFeature]) {
        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView.style else { return }

        // You can add custom UIImages to the map style.
        // These can be referenced by an MGLSymbolStyleLayer’s iconImage property.
        style.setImage(UIImage(named: "lighthouse")!, forName: "lighthouse")

        // Add the features to the map as a shape source.
        let source = MGLShapeSource(identifier: "lighthouses")
        style.addSource(source)

        let lighthouseColor = UIColor(red: 0.08, green: 0.44, blue: 0.96, alpha: 1.0)

        // Use MGLCircleStyleLayer to represent the points with simple circles.
        // In this case, we can use style functions to gradually change properties between zoom level 2 and 7: the circle opacity from 50% to 100% and the circle radius from 2pt to 3pt.
        let circles = MGLCircleStyleLayer(identifier: "lighthouse-circles", source: source)
        circles.circleColor = MGLStyleValue(rawValue: lighthouseColor)
        circles.circleOpacity = MGLStyleValue(stops: [
            2: MGLStyleValue(rawValue: 0.5),
            7: MGLStyleValue(rawValue: 1),
        ])
        circles.circleRadius = MGLStyleValue(stops: [
            2: MGLStyleValue(rawValue: 2),
            7: MGLStyleValue(rawValue: 3),
        ])

        // Use MGLSymbolStyleLayer for more complex styling of points including custom icons and text rendering.
        let symbols = MGLSymbolStyleLayer(identifier: "lighthouse-symbols", source: source)
        symbols.iconImageName = MGLStyleValue(rawValue: "lighthouse")
        symbols.iconColor = MGLStyleValue(rawValue: lighthouseColor)
        symbols.iconScale = MGLStyleValue(rawValue: 0.5)
        symbols.iconOpacity = MGLStyleValue(stops: [
            5.9: MGLStyleValue(rawValue: 0),
            6: MGLStyleValue(rawValue: 1)
        ])
        symbols.iconHaloColor = MGLStyleValue(rawValue: UIColor.white.withAlphaComponent(0.5))
        symbols.iconHaloWidth = MGLStyleValue(rawValue: 1)
        // {name} references the "name" key in an MGLPointFeature’s attributes dictionary.
        symbols.text = MGLStyleValue(rawValue: "{name}")
        symbols.textColor = symbols.iconColor
        symbols.textFontSize = MGLStyleValue(stops: [
            10: MGLStyleValue(rawValue: 10),
            16: MGLStyleValue(rawValue: 16)
        ])
        symbols.textTranslation = MGLStyleValue(rawValue: NSValue(cgVector: CGVector(dx: 10, dy: 0)))
        symbols.textOpacity = symbols.iconOpacity
        symbols.textHaloColor = symbols.iconHaloColor
        symbols.textHaloWidth = symbols.iconHaloWidth
        symbols.textJustification = MGLStyleValue(rawValue: NSValue(mglTextJustification: .left))
        symbols.textAnchor = MGLStyleValue(rawValue: NSValue(mglTextAnchor: .left))

        style.addLayer(circles)
        style.addLayer(symbols)
    }

    // MARK: - Feature interaction
    func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Limit feature selection to just the following layer identifiers.
            let layerIdentifiers = ["lighthouse-symbols", "lighthouse-circles"]

            // Try matching the exact point first.
            let point = sender.location(in: sender.view!)
            for f in mapView.visibleFeatures(at: point, styleLayerIdentifiers: Set(layerIdentifiers)) {
                if let f = f as? MGLPointFeature {
                    self.showCallout(feature: f)
                    return
                }
            }

            let touchCoordinate = mapView.convert(point, toCoordinateFrom: sender.view!)
            let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)

            // Otherwise, get all features within a rect the size of a touch (44x44).
            let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
            var possibleFeatures = [MGLPointFeature]()
            for f in mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(layerIdentifiers)) {
                if let f = f as? MGLPointFeature {
                    possibleFeatures.append(f)
                }
            }

            // Select the closest feature to the touch center.
            let closestFeatures = possibleFeatures.sorted(by: { (a, b) -> Bool in
                return CLLocation(latitude: a.coordinate.latitude, longitude: a.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: b.coordinate.latitude, longitude: b.coordinate.longitude).distance(from: touchLocation)
            })
            if let f = closestFeatures.first {
                self.showCallout(feature: f)
                return
            }
            
            // If no features were found, deselect the selected annotation, if any.
            self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        }
    }

    func showCallout(feature: MGLPointFeature) {
        let point = MGLPointFeature()
        point.title = feature.attributes["name"] as? String
        point.coordinate = feature.coordinate

        // Selecting an feature that doesn’t already exist on the map will add a new annotation view.
        // We’ll need to use the map’s delegate methods to add an empty annotation view and remove it when we’re done selecting it.
        mapView.selectAnnotation(point, animated: true)
    }

    // MARK: - MGLMapViewDelegate

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        mapView.removeAnnotations([annotation])
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return MGLAnnotationView()
    }

    // MARK: - Data fetching and parsing

    func fetchPoints(withCompletion completion: @escaping (([MGLFeature]) -> Void)) {
        // Wikidata query for all lighthouses in the United States: https://query.wikidata.org/#%23added%20before%202016-10%0A%23defaultView%3AMap%0ASELECT%20DISTINCT%20%3Fitem%20%3FitemLabel%20%3Fcoor%20%3Fimage%0AWHERE%0A%7B%0A%09%3Fitem%20wdt%3AP31%20wd%3AQ39715%20.%20%0A%09%3Fitem%20wdt%3AP17%20wd%3AQ30%20.%0A%09%3Fitem%20wdt%3AP625%20%3Fcoor%20.%0A%09OPTIONAL%20%7B%20%3Fitem%20wdt%3AP18%20%3Fimage%20%7D%20%20%0A%09SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%20%7D%20%20%0A%7D%0AORDER%20BY%20%3FitemLabel
        let query = "SELECT DISTINCT ?item " +
            "?itemLabel ?coor ?image " +
            "WHERE " +
            "{ " +
            "?item wdt:P31 wd:Q39715 . " +
            "?item wdt:P17 wd:Q30 . " +
            "?item wdt:P625 ?coor . " +
            "OPTIONAL { ?item wdt:P18 ?image } . " +
            "SERVICE wikibase:label { bd:serviceParam wikibase:language \"en\" } " +
            "} " +
        "ORDER BY ?itemLabel"

        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: CharacterSet.urlQueryAllowed)
        characterSet.removeCharacters(in: "?")
        characterSet.removeCharacters(in: "&")
        characterSet.removeCharacters(in: ":")

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!

        let request = URLRequest(url: URL(string: "https://query.wikidata.org/sparql?query=\(encodedQuery)&format=json")!)

        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options:[]) as? [String: AnyObject] else { return }
            guard let results = json?["results"] as? [String: AnyObject] else { return }
            guard let items = results["bindings"] as? [[String: AnyObject]] else { return }
            DispatchQueue.main.async {
            completion(self.parseJSONItems(items: items))
            }
        }).resume()
    }

    func parseJSONItems(items: [[String: AnyObject]]) -> [MGLFeature] {
        var features = [MGLFeature]()
        for item in items {
            guard let label = item["itemLabel"] as? [String: AnyObject],
            let title = label["value"] as? String else { continue }
            guard let coor = item["coor"] as? [String: AnyObject],
            let point = coor["value"] as? String else { continue }

            let parsedPoint = point.replacingOccurrences(of: "Point(", with: "").replacingOccurrences(of: ")", with: "")
            let pointComponents = parsedPoint.components(separatedBy: " ")
            let coordinate = CLLocationCoordinate2D(latitude: Double(pointComponents[1])!, longitude: Double(pointComponents[0])!)
            let feature = MGLPointFeature()
            feature.coordinate = coordinate
            feature.title = title
            // A feature’s attributes can used by runtime styling for things like text labels.
            feature.attributes = [
                "name": title
            ]
            features.append(feature)
        }
        return features
    }
}
#endif
