import Mapbox

@objc(ClusteringExample_Swift)

class ClusteringExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var progressView: UIProgressView!
    var downloadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 44.645208223, longitude: -63.0175781)
        mapView.zoomLevel = 6.5
        mapView.delegate = self
        view.addSubview(mapView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        
        // Data pulled from: "https://opendata.arcgis.com/datasets/47fe59959754485c9025e7249444c94f_0.geojson
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "halifax", ofType: "geojson")!)
        let source = MGLShapeSource(identifier: "clusteredPorts",
                                    url: url,
                                    options: [.clustered: true, .clusterRadius: 50])
        style.addSource(source)
        
        // Unclustered symbols
        let ports = MGLSymbolStyleLayer(identifier: "ports", source: source)
        ports.iconImageName = NSExpression(forConstantValue: "harbor-15")
        ports.predicate = NSPredicate(format: "cluster != YES")
        style.addLayer(ports)
        
        // Clustered circles
        let stops = [
            1:  UIColor.lightGray,
            5:  UIColor.orange,
            7: UIColor.red,
            9: UIColor.purple
        ]
        
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPorts", source: source)
        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: 18))
        circlesLayer.circleOpacity = NSExpression(forConstantValue: 0.75)
        circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.75))
        circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circlesLayer.circleColor = NSExpression(format: "mgl_step:from:stops:(point_count, %@, %@)", UIColor.lightGray, stops)
        circlesLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(circlesLayer)
        
        // Labels for clustered circles
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: 12))
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        
        numbersLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(numbersLayer)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        downloadButton = UIButton(frame: CGRect(x: 20, y: 50, width: 150, height: 40))
        downloadButton.setTitle("Download map", for: .normal)
        downloadButton.backgroundColor = .blue
        downloadButton.addTarget(self, action: #selector(startOfflinePackDownload(sender:)), for: .touchUpInside)
        mapView.addSubview(downloadButton)
    }
    
    @objc func startOfflinePackDownload(sender: UIButton) {
        
        downloadButton.setTitle("Downloading...", for: .disabled)
        downloadButton.backgroundColor = UIColor(red: 0, green: 0, blue: 50, alpha: 0.5)
        downloadButton.isEnabled = false
        
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: 11)
        
        let userInfo = ["name": "Halifax offline pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            pack!.resume()
        }
    }
    
    @objc func offlinePackProgressDidChange(notification: NSNotification) {

        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
                view.addSubview(progressView)
            }
            
            progressView.progress = progressPercentage
            
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
                
                downloadButton.setTitle("Downlowded", for: .disabled)
            } else {
                print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
