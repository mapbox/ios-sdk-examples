import Mapbox

@objc(ClusteringExample_Swift)

class ClusteringExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var icon: UIImage!
    var popup: UILabel?
    
    var circleImage: UIImage!
    var rectangleImage: UIImage!
    var starImage: UIImage!
    var polygonImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        mapView.delegate = self
        view.addSubview(mapView)

        // Add a single tap gesture recognizer. This gesture requires the built-in MGLMapView tap gestures (such as those for zoom and annotation selection) to fail.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)

        icon = UIImage(named: "port")
        
        circleImage = UIImage(named: "circle")
        rectangleImage = UIImage(named: "rectangle")
        starImage = UIImage(named: "star")
        polygonImage = UIImage(named: "polygon")
        
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)

        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: [.clustered: true, .clusterRadius: icon.size.width])
        style.addSource(source)

        // Use a template image so that we can tint it with the `iconColor` runtime styling property.
        style.setImage(icon.withRenderingMode(.alwaysTemplate), forName: "icon")

        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
        let ports = MGLSymbolStyleLayer(identifier: "ports", source: source)
        ports.iconImageName = NSExpression(forConstantValue: "icon")
        ports.iconColor = NSExpression(forConstantValue: UIColor.darkGray.withAlphaComponent(0.9))
        ports.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(ports)

        // Color clustered features based on clustered point counts.
        style.setImage(icon.withRenderingMode(.alwaysOriginal), forName: "circle")
        style.setImage(icon.withRenderingMode(.alwaysOriginal), forName: "rectangle")
        style.setImage(icon.withRenderingMode(.alwaysOriginal), forName: "star")
        style.setImage(icon.withRenderingMode(.alwaysOriginal), forName: "polygon")
        
        let stops = [
            20:  NSExpression(forConstantValue: "circle"),
            50:  NSExpression(forConstantValue: "rectangle"),
            100: NSExpression(forConstantValue: "star"),
            200: NSExpression(forConstantValue: "polygon")
        ]

        // Show clustered features as circles. The `point_count` attribute is built into clustering-enabled source features.
//        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPorts", source: source)
//        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
//        circlesLayer.circleOpacity = NSExpression(forConstantValue: 0.75)
//        circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.75))
//        circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
//        circlesLayer.circleColor = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", UIColor.lightGray, stops)
//        circlesLayer.predicate = NSPredicate(format: "cluster == YES")
//        style.addLayer(circlesLayer)
        
        

        // Label cluster circles with a layer of text indicating feature count. The value for `point_count` is an integer. In order to use that value for the `MGLSymbolStyleLayer.text` property, cast it as a string. 
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        numbersLayer.iconImageName = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", NSExpression(forConstantValue: "polygon"), stops)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        
        numbersLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(numbersLayer)
    }

    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        showPopup(false, animated: false)
    }

    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: sender.view)
            let width = icon.size.width
            let rect = CGRect(x: point.x - width / 2, y: point.y - width / 2, width: width, height: width)

            let clusters = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["clusteredPorts"])
            let ports = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["ports"])

            if clusters.count > 0 {
                showPopup(false, animated: true)
                let cluster = clusters.first!
                mapView.setCenter(cluster.coordinate, zoomLevel: (mapView.zoomLevel + 1), animated: true)
            } else if ports.count > 0 {
                let port = ports.first!

                if popup == nil {
                    popup = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                    popup!.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                    popup!.layer.cornerRadius = 4
                    popup!.layer.masksToBounds = true
                    popup!.textAlignment = .center
                    popup!.lineBreakMode = .byTruncatingTail
                    popup!.font = UIFont.systemFont(ofSize: 16)
                    popup!.textColor = UIColor.black
                    popup!.alpha = 0
                    view.addSubview(popup!)
                }

                popup!.text = (port.attribute(forKey: "name")! as! String)
                let size = (popup!.text! as NSString).size(withAttributes: [NSAttributedStringKey.font: popup!.font])
                popup!.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: -10, dy: -10)
                let point = mapView.convert(port.coordinate, toPointTo: mapView)
                popup!.center = CGPoint(x: point.x, y: point.y - 50)

                if popup!.alpha < 1 {
                    showPopup(true, animated: true)
                }
            } else {
                showPopup(false, animated: true)
            }
        }
    }

    func showPopup(_ shouldShow: Bool, animated: Bool) {
        let alpha: CGFloat = (shouldShow ? 1 : 0)
        if animated {
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.popup?.alpha = alpha
            }
        } else {
            popup?.alpha = alpha
        }
    }

}
