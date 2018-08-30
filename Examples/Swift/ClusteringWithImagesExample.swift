import Mapbox

@objc(ClusteringWithImagesExample_Swift)

class ClusteringWithImagesExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the Map
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Define an initial icon to help set source attributes
        let icon = UIImage(named: "squircle")!

        // Retrieve data and set as source. This associates the data with the map, but style layers are still required to make data visible.
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "ports", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: [.clustered: true, .clusterRadius: icon.size.width])
        style.addSource(source)

        // Show unclustered features as icons. The `cluster` attribute is built into clustering-enabled source features.
        // This example requires two style layers to work properly: one for clustered points and one for unclustered points
        let markerLayer = MGLSymbolStyleLayer(identifier: "ports", source: source)
        markerLayer.iconImageName = NSExpression(forConstantValue: "marker")
        markerLayer.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(markerLayer)
        style.setImage(UIImage(named: "marker")!, forName: "marker")

        // Create style layer to cluster features as images with labels
        let clusterLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        clusterLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        clusterLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(icon.size.width) / 2))
        clusterLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)

        // Style image clusters
        style.setImage(UIImage(named: "squircle")!, forName: "squircle")
        style.setImage(UIImage(named: "circle")!, forName: "circle")
        style.setImage(UIImage(named: "rectangle")!, forName: "rectangle")
        style.setImage(UIImage(named: "star")!, forName: "star")
        style.setImage(UIImage(named: "oval")!, forName: "oval")

        let stops = [
            10: NSExpression(forConstantValue: "circle"),
            25: NSExpression(forConstantValue: "rectangle"),
            75: NSExpression(forConstantValue: "star"),
            150: NSExpression(forConstantValue: "oval")
        ]

        // Use expressions to set each cluster's image based on defined stops and display the point count over the corresponding image
        let defaultShape = NSExpression(forConstantValue: "squircle")
        clusterLayer.iconImageName = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", defaultShape, stops)
        clusterLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")

        style.addLayer(clusterLayer)
    }

}
