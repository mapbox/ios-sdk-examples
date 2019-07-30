import Mapbox

@objc(CacheManagementExample_Swift)

class CacheManagementExample_Swift: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL)
        mapView.delegate = self
        view.addSubview(mapView)

        // Create an offline pack.
        addOfflinePack()

        /* Add a bar button. Tapping this button will present a menu of options. For this example, the cache is managed through the UI. It can also be managed by developers through remote notifications.
         For more information about managing remote notifications in your iOS app, see the Apple "UserNotifications" documentation: https://developer.apple.com/documentation/usernotifications
 */
        let alertButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(presentActionSheet))
       self.navigationController?.navigationItem.setRightBarButton(alertButton, animated: false)
    }

    // MARK: Cache management methods called by action sheet

    /* Check whether the tiles locally cached match those on the tile server. If the local tiles are out-of-date, they will be updated. Invalidating the ambient cache is preferred to clearing the cache. Tiles shared with offline packs will not be affected by this method.
      The ambient cache is created through the end user loading and using a map view.
 */
    func invalidateAmbientCache() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.invalidateAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start
           // Display an alert to indicate that the invalidation is complete.
            self.presentCompletionAlertWithContent(title: "Invalidated Ambient Cache", message: "Invalidated ambient cache in \(difference) seconds")
        }
    }

    // Check whether the local offline tiles match those on the tile server. If the local tiles are out-of-date, they will be updated. Invalidating an offline pack is preferred to removing and reinstalling the pack.
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
               // Display an alert to indicate that the invalidation is complete.
                self.presentCompletionAlertWithContent(title: "Offline Pack Invalidated", message: "Invalidated offline pack in \(difference) seconds")            }
        }
    }

    // This removes resources from the ambient cache. Resources which overlap with offline packs will not be impacted.
    func clearAmbientCache() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.clearAmbientCache { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start
           // Display an alert to indicate that the ambient cache has been cleared.
            self.presentCompletionAlertWithContent(title: "Cleared Ambient Cache", message: "Ambient cache has been cleared in \(difference) seconds.")
        }
    }

    // This method deletes the cache.db file, then reinitializes it. This deletes offline packs and ambient cache resources. You should not need to call this method. Invalidating the ambient cache and/or offline packs should be sufficient for most use cases.
    func resetDatabase() {
        let start = CACurrentMediaTime()
        MGLOfflineStorage.shared.resetDatabase { (error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            let difference = CACurrentMediaTime() - start

            // Display an alert to indicate that the cache.db file has been reset.
            self.presentCompletionAlertWithContent(title: "Database Reset", message: "The cache.db file has been reset in \(difference) seconds.")
        }
    }

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

    // MARK: Add UI components

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
            .sourceView = mapView
        present(alertController, animated: true, completion: nil)
    }

    func presentCompletionAlertWithContent(title: String, message: String) {
        let completionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        completionController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        self.present(completionController, animated: false, completion: nil)
    }
}
