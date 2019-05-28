import UIKit
import Mapbox

@objc(TextFormattingExample_Swift)

class TextFormattingExample_Swift: UIViewController {

    let mapView = MGLMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: This is a test case, it should be changed to fulfill an ios example spec.
        mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.styleURL = MGLStyle.streetsStyleURL
        mapView.setCenter(CLLocationCoordinate2D(latitude: 36.374782, longitude: -119.620859), zoomLevel: 6, animated: false)
        view.addSubview(mapView)

        // Create a UISegmentedControl to toggle between map styles
        let styleToggle = UISegmentedControl(items: ["Expression", "JSON"])
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
        styleToggle.backgroundColor = UIColor(red: 0.973, green: 0.329, blue: 0.294, alpha: 1)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(formatText(sender:)), for: .valueChanged)

        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -20)])
    }

    // Format label's text based on the selected index of the UISegmentedControl
    @objc func formatText(sender: UISegmentedControl) {
        let stateLayer = mapView.style?.layer(withIdentifier: "state-label") as? MGLSymbolStyleLayer
        var expression: NSExpression = NSExpression(forConstantValue: "")

        switch sender.selectedSegmentIndex {
        case 0:
            let firstRowAttribute = MGLAttributedExpression(expression: NSExpression(format: "name"))
            let lineBreak = MGLAttributedExpression(expression: NSExpression(forConstantValue: "\n"))
            let formatAttribute = MGLAttributedExpression(expression: NSExpression(format: "name"),
                                                          attributes: [.fontScaleAttribute: NSExpression(forConstantValue: 0.8),
                                                                       .fontColorAttribute: NSExpression(forConstantValue: "blue"),
                                                                       .fontNamesAttribute: NSExpression(forConstantValue: ["Arial Unicode MS Bold"])])
            let attributedExpression = NSExpression(format: "mgl_attributed:(%@, %@, %@)", NSExpression(forConstantValue: firstRowAttribute),
                                                                                            NSExpression(forConstantValue: lineBreak),
                                                                                            NSExpression(forConstantValue: formatAttribute))

            expression = NSExpression(format: "MGL_MATCH(2 - 1,  1, %@, 'Foo')", attributedExpression)

        case 1:
            let fileURL: URL = Bundle.main.url(forResource: "text-format", withExtension: "json")!
            let data = try? Data(contentsOf: fileURL)
            let jsonWithObjectRoot = try? JSONSerialization.jsonObject(with: data!, options: [])

            if let jsonExpression = jsonWithObjectRoot as? [String: Any],
                let jsonArray = jsonExpression["expression"] as? [Any] {
                expression = NSExpression(mglJSONObject: jsonArray)
            }

        default:
            expression = NSExpression(forConstantValue: "default")
        }

        stateLayer?.text = expression
    }

}
