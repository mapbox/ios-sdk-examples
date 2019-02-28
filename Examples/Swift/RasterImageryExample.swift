import Mapbox

@objc(RasterImageryExample_Swift)

class RasterImageryExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var rasterLayer: MGLRasterStyleLayer?
    var secondRasterLayer: MGLRasterStyleLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.5188, longitude: -122.6748), zoomLevel: 13, animated: false)

        mapView.delegate = self

        view.addSubview(mapView)

        // Add a UISlider that will control the raster layer’s opacity.
        addSlider()
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        // Add a new raster source and layer.
        let source = MGLRasterTileSource(identifier: "stamen-watercolor", tileURLTemplates: ["https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg"], options: [ .tileSize: 256 ])
        let rasterLayer = MGLRasterStyleLayer(identifier: "stamen-watercolor", source: source)

        let secondSource = MGLRasterTileSource(identifier: "cloud-cover", tileURLTemplates: ["https://re.ssec.wisc.edu/api/image?products=G16-ABI-FD-BAND02&x={x}&y={y}&z={z}&client=RealEarth&device=Browser"], options: [ .tileSize: 256 ])
        let secondRasterLayer = MGLRasterStyleLayer(identifier: "cloud-cover", source: secondSource)

        style.addSource(source)
        style.addLayer(rasterLayer)
        style.addSource(secondSource)
        style.addLayer(secondRasterLayer)

        self.rasterLayer = rasterLayer
        self.secondRasterLayer = secondRasterLayer
        rasterLayer.rasterOpacity = NSExpression(forConstantValue: 0.5)
        secondRasterLayer.rasterOpacity = NSExpression(forConstantValue: 0.5)
    }

    @objc func updateLayerOpacity(_ sender: UISlider) {
        rasterLayer?.rasterOpacity = NSExpression(forConstantValue: sender.value as NSNumber)
        secondRasterLayer?.rasterOpacity = NSExpression(forConstantValue: (1 - sender.value) as NSNumber)
    }

    func addSlider() {
        let padding: CGFloat = 10
        let slider = UISlider(frame: CGRect(x: padding, y: self.view.frame.size.height - 44 - 30, width: self.view.frame.size.width - padding *  2, height: 44))
        slider.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.addTarget(self, action: #selector(updateLayerOpacity), for: .valueChanged)
        view.addSubview(slider)
    }
}
