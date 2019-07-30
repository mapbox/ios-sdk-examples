import Mapbox

@objc(CacheManagementExample_Swift)

class CacheManagementExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var alertController: UIAlertController!
    var alertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL)
        mapView.delegate = self
        view.addSubview(mapView)

        addOfflinePack()
        addButton()
    }

    // Create an offline pack.
    func addOfflinePack() {
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: 0, toZoomLevel: 2)

        let info = ["name": "Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: info)
        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            pack?.resume()
        }
    }

    // MARK: Cache management methods called by action sheet
    func invalidateAmbientCache() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.invalidateAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start
            self.presentCompletionAlertWithContent(title: "Invalidated Ambient Cache", message: "Invalidated ambient cache in \(difference) seconds")
        }
    }
    
    func invalidateOfflinePack() {

        if let pack = MGLOfflineStorage.shared.packs?.first {
            let start = CACurrentMediaTime()
            MGLOfflineStorage.shared.invalidatePack(pack) { (error) in
                guard error == nil else {
                    // The pack couldn’t be invalidated for some reason.
                    print("Error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                let difference = CACurrentMediaTime() - start
                self.presentCompletionAlertWithContent(title: "Offline Pack Invalidated", message: "Invalidated offline pack in \(difference) seconds")            }
        }
    }

    // This deletes the 
    func clearAmbientCache() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.clearAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start
            self.presentCompletionAlertWithContent(title: "Cleared Ambient Cache", message: "Ambient cache has been cleared in \(difference) seconds.")
        }
    }

    // This method deletes the cache.db file, then reinitializes it. This deletes offline packs and ambient cache resources. You should not need to call this method.
    func resetDatabase() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.resetDatabase { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start
            self.presentCompletionAlertWithContent(title: "Database Reset", message: "The cache.db file has been reset in \(difference) seconds.")
        }
    }

    // MARK: Add UI components
    func addButton() {
        alertButton = UIButton(type: .roundedRect)
        alertButton.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.backgroundColor = .purple

        view.insertSubview(alertButton, aboveSubview: mapView)

        NSLayoutConstraint.activate([NSLayoutConstraint(item: alertButton!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mapView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0)])
        NSLayoutConstraint.activate([NSLayoutConstraint(item: alertButton!, attribute: .bottom, relatedBy: .equal, toItem: mapView.attributionButton, attribute: .top, multiplier: 1, constant: 0)])

        alertButton.addTarget(self, action:
            #selector(presentActionSheet), for: .touchUpInside)
    }

    // Create an action sheet that handles the cache management.
    @objc func presentActionSheet() {
        if (alertController == nil) {
            alertController = UIAlertController(title: "Cache Management Options", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Invalidate Ambient Cache", style: .default, handler: { (action) in
                self.invalidateAmbientCache()
            }))
            alertController.addAction(UIAlertAction(title: "Invalidate Offline Pack", style: .default, handler: { (action) in
                self.invalidateOfflinePack()
            }))
            alertController.addAction(UIAlertAction(title: "Clear Ambient Cache", style: .default, handler: { (action) in
                self.clearAmbientCache()
            }))
            alertController.addAction(UIAlertAction(title: "Reset Database", style: .default, handler: { (action) in
                self.resetDatabase()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }

        alertController.popoverPresentationController?
            .sourceRect = alertButton.bounds
        present(alertController, animated: true, completion: nil)
    }

    func presentCompletionAlertWithContent(title: String, message: String) {
        let completionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        completionController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        self.present(completionController, animated: false, completion: nil)
    }
}
