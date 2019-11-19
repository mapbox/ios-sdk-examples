import Mapbox

@objc(RasterImageryExample_Swift)

class RasterImageryExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var rasterLayer: MGLRasterStyleLayer?

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

        style.addSource(source)
        style.addLayer(rasterLayer)

        self.rasterLayer = rasterLayer
    }

    @objc func updateLayerOpacity(_ sender: UISlider) {
        rasterLayer?.rasterOpacity = NSExpression(forConstantValue: sender.value as NSNumber)
    }

    func addSlider() {
        let padding: CGFloat = 10
        let slider = UISlider(frame: CGRect(x: padding, y: self.view.frame.size.height - 44 - 30, width: self.view.frame.size.width - padding *  2, height: 44))
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(updateLayerOpacity), for: .valueChanged)
        view.insertSubview(slider, aboveSubview: mapView)
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            slider.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                slider.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -mapView.logoView.bounds.height - 10),
                slider.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - padding *  2),
                slider.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            ]

            NSLayoutConstraint.activate(constraints)
        } else {
            slider.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        }
    }
}
