
import Mapbox

@objc(MultipleImagesExample_Swift)

class MultipleImagesExample: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and add a map view.
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)
        
        // Center the map on Yosemite National Park, United States.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 37.761, longitude: -119.624), zoomLevel: 10, animated: false)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Add icons from the U.S. National Parks Service to the map's style.
        style.setImage(UIImage(named: "nps-restrooms")!, forName: "restrooms")
        style.setImage(UIImage(named: "nps-trailhead")!, forName: "trailhead")
        style.setImage(UIImage(named: "nps-picnic-area")!, forName: "picnic-area")
        
        // Access a vector tileset that contains places of interest at Yosemite National Park. This tileset was created by uploading NPS shapefiles to Mapbox Studio.
        if let url = URL(string: "mapbox://examples.ciuz0vpc") {
            
            // Add the vector tileset to the map's style.
            let source = MGLVectorTileSource(identifier: "yosemite-pois", configurationURL: url)
            style.addSource(source)
            
            // Create a symbol style layer and access the layer containin
            let layer = MGLSymbolStyleLayer(identifier: "yosemite-pois", source: source)
            
            // Access the layer that contains the POI data.
            layer.sourceLayerIdentifier = "Yosemite_POI-38jhes"
            
            // Create a stops dictionary with keys that are possible values for 'POITYPE', paired with icon images that will represent those features.
            let poiIcons = ["Picnic Area" : "picnic-area", "Restroom" : "restrooms", "Trailhead" : "trailhead"]
            
            // Use the stops dictionary to assign an icon based on the "POITYPE" for each feature.
            layer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', POITYPE)", poiIcons)

            style.addLayer(layer)
        }
    }
}
