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
	mapView.delegate = self

	view.addSubview(mapView)

	self.mapView = mapView
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
	self.loadAnnotations()
    }

    func loadAnnotations() {
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

	var characterSet = NSMutableCharacterSet()
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
		self.mapItems(items: items)
	    }
	}).resume()
    }

    func mapItems(items: [[String: AnyObject]]) {
	let features = parseJSONItems(items: items)

	let source = MGLGeoJSONSource(identifier: "lighthouses", features: features, options: nil)

	let lighthouseColor = UIColor(red: 0.45, green: 0.32, blue: 0.23, alpha: 1.0)

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

	let symbols = MGLSymbolStyleLayer(identifier: "lighthouse-symbols", source: source)
	symbols.iconImage = MGLStyleValue(rawValue: "circle-15")
	symbols.iconColor = MGLStyleValue(rawValue: lighthouseColor)
	symbols.iconOpacity = MGLStyleValue(stops: [
	    5.9: MGLStyleValue(rawValue: 0),
	    6: MGLStyleValue(rawValue: 1)
	    ])
	symbols.iconHaloColor = MGLStyleValue(rawValue: UIColor.white.withAlphaComponent(0.5))
	symbols.iconHaloWidth = MGLStyleValue(rawValue: 1)
	symbols.textColor = symbols.iconColor
	symbols.textField = MGLStyleValue(rawValue: "{name}")
	symbols.textSize = MGLStyleValue(stops: [
	    10: MGLStyleValue(rawValue: 10),
	    16: MGLStyleValue(rawValue: 16)
	    ])
	symbols.textTranslate = MGLStyleValue(rawValue: NSValue(cgVector: CGVector(dx: 10, dy: 0)))
	symbols.textOpacity = symbols.iconOpacity
	symbols.textHaloColor = symbols.iconHaloColor
	symbols.textHaloWidth = symbols.iconHaloWidth
	symbols.textJustify = MGLStyleValue(rawValue: NSValue(mglTextJustify: .left))
	symbols.textAnchor = MGLStyleValue(rawValue: NSValue(mglTextAnchor: .left))

	self.mapView.style().add(source)
	self.mapView.style().add(circles)
	self.mapView.style().add(symbols)
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
	    feature.attributes = [
		"name": title
	    ]
	    features.append(feature)
	}
	return features
    }
}
#endif
