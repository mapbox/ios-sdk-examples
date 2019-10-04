import Mapbox
import UIKit

@objc(FilterMapSymbolsExample_Swift)


class ViewController: UIViewController, MGLMapViewDelegate {
    
    
    var mapView: MGLMapView!
    var feature : MGLShapeCollectionFeature!
    var style : MGLStyle!
    var symbolLayer : MGLSymbolStyleLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = URL(string: "mapbox://styles/zizim/ck12h05if04ha1co4qr1ra9l2")
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.897435, longitude: -77.039679), zoomLevel: 11, animated: false)
        
        mapView.delegate = self
        view.addSubview(mapView)
        
        toggleSet()
        
    }
    
    func toggleSet() {

        // Create a UISegmentedControl to toggle between map icons
        let styleToggle = UISegmentedControl(items: ["theatre", "bar", "music", "biking"])

        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        styleToggle.tintColor = UIColor(red: 0.976, green: 0.843, blue: 0.831, alpha: 1)
        styleToggle.backgroundColor = UIColor(red: 0.09, green: 0.568, blue: 0.514, alpha: 0.56)
        styleToggle.layer.cornerRadius = 4
        styleToggle.clipsToBounds = true
//        styleToggle.selectedSegmentIndex = 0

        view.insertSubview(styleToggle, aboveSubview: mapView)
        styleToggle.addTarget(self, action: #selector(changeIcon(sender:)), for: .valueChanged)

        // Configure autolayout constraints for the UISegmentedControl to align
        // at the bottom of the map view and above the Mapbox logo and attribution
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: styleToggle, attribute: .bottom, relatedBy: .equal, toItem: mapView.logoView, attribute: .top, multiplier: 1, constant: -10)])
        
    }
    
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Parse the GeoJSON data.
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "iOS", withExtension: "geojson") else {
                preconditionFailure("Failed to load local GeoJSON file")
            }
            
            guard let data = try? Data(contentsOf: url) else {
                preconditionFailure("Failed to decode GeoJSON file")
            }
            
            DispatchQueue.main.async {
                try? self.drawShapeCollection(data: data)
                
            }
           
        }
    }
    
    func drawShapeCollection(data: Data) throws {
        style = self.mapView.style
        
        // Use [MGLShape shapeWithData:encoding:error:] to create a MGLShapeCollectionFeature from GeoJSON data.
        guard let feature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else {
            fatalError("Could not cast to specified MGLShapeCollectionFeature")
        }
    
        // Create source and add it to the map style.
        let source = MGLShapeSource(identifier: "places", shape: feature, options: nil)
        style.addSource(source)
        
        
//        //add each icon to the map
       symbolLayer = MGLSymbolStyleLayer(identifier: "icons", source: source)
            
            let stops = [
                    "theatre": NSExpression(forConstantValue: "theatre-15"),
                     "bar": NSExpression(forConstantValue: "alcohol-shop-15"),
                     "music": NSExpression(forConstantValue: "music-15"),
                     "bicycle": NSExpression(forConstantValue: "bicycle-15")
                    
                    ]
                
        symbolLayer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', icon)", stops)
                print("okay ...\(stops)")
             
        style.addLayer(symbolLayer)
        
        }

    
    
    
    // Change the map style based on the selected index of the UISegmentedControl
    @objc func changeIcon(sender: UISegmentedControl) {
        if symbolLayer != nil {
            switch sender.selectedSegmentIndex {
                 case 0:
                symbolLayer.iconImageName = NSExpression(forConstantValue: "theatre-15")
                symbolLayer.predicate = NSPredicate(format: "icon = 'theatre'")
                 case 1:
                 symbolLayer.iconImageName = NSExpression(forConstantValue: "alcohol-shop-15")
                 symbolLayer.predicate = NSPredicate(format: "icon = 'bar'")
                 case 2:
                 symbolLayer.iconImageName = NSExpression(forConstantValue: "music-15")
                 symbolLayer.predicate = NSPredicate(format: "icon = 'music'")
                 case 3:
                 symbolLayer.iconImageName = NSExpression(forConstantValue: "bicycle-15")
                 symbolLayer.predicate = NSPredicate(format: "icon = 'bicycle'")
                 default:
                 symbolLayer.iconImageName = NSExpression(forConstantValue: "circle-15")
                         
            }
            
        }
        
}

}
