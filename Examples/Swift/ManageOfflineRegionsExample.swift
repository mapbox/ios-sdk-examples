import Mapbox

@objc(ManageOfflineRegionsExample_Swift)

class ManageOfflineRegionsExample_Swift: UIViewController, MGLMapViewDelegate, UITableViewDelegate, UITableViewDataSource  {

        var mapView: MGLMapView!
        var progressView: UIProgressView!
        var downloadButton = UIButton(frame: CGRect.zero)
        var tableView = UITableView()
        var regionCount = 0
        var regionArray = [MGLTilePyramidOfflineRegion]()
        var packArray = [MGLOfflinePack]()
        var userInfo = [String]()
        var pack = MGLOfflineStorage.shared.packs
        var progressPercentage: Float?

        override func viewDidLoad() {

            super.viewDidLoad()

            mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 1.5), styleURL: MGLStyle.darkStyleURL)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.tintColor = .gray
            mapView.delegate = self

            tableView.frame = CGRect(x: 0, y: mapView.frame.maxY, width: view.bounds.width, height: view.bounds.height / 3.5)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.rowHeight = 50
            
            downloadButton.backgroundColor = UIColor.white
            downloadButton.setTitleColor(.black, for: .normal)
            downloadButton.setTitle("Download Region", for: .normal)
            downloadButton.addTarget(self, action: #selector(startOfflinePackDownload), for: .touchUpInside)
            downloadButton.layer.cornerRadius = view.bounds.width / 30
            downloadButton.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(mapView)
            view.addSubview(tableView)
            view.addSubview(downloadButton)
            mapView.setCenter(CLLocationCoordinate2D(latitude: 22.27933, longitude: 114.16281),

                              zoomLevel: 13, animated: false)

            // Setup offline pack notification handlers.
            NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
            installConstraints()
        }

        func installConstraints() {

            if #available(iOS 11.0, *) {
                NSLayoutConstraint.activate([
                    downloadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    downloadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -170),
                    downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
                ])
            } else {
                // Fallback on earlier versions
            }

        }

        override func viewDidDisappear(_ animated: Bool) {

            super.viewDidDisappear(animated)
            // When leaving this view controller, suspend offline downloads.
            guard let packs = MGLOfflineStorage.shared.packs else { return }
            for pack in packs {
                if let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
                    print("Suspending download of offline pack: “\(userInfo["name"] ?? "unknown")”")
                }
                pack.suspend()
            }
        }

        deinit {
            // Remove offline pack observers.
            print("Removing offline pack notification observers")
            NotificationCenter.default.removeObserver(self)

        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if packArray.isEmpty  {
                return 1
            } else {
                return packArray.count
            }

        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if MGLOfflineStorage.shared.packs?.count != nil {
                let progress = Float(packArray[indexPath.row].progress.countOfResourcesCompleted)/Float(packArray[indexPath.row].progress.countOfResourcesExpected)
                cell.textLabel!.text = "Region \(indexPath.row + 1): \n  Percent completion: \(String(format: "%.2f", progress * 100)) %"
                print(Float((packArray[indexPath.row].progress.countOfResourcesCompleted)/(packArray[indexPath.row].progress.countOfResourcesExpected) * 100))

                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.lineBreakMode = .byWordWrapping
                if #available(iOS 13.0, *) {
                    cell.textLabel?.textColor = .darkGray
                } else {
                    // Fallback on earlier versions
                }
                cell.textLabel?.textAlignment = .left

            } else {

                cell.textLabel?.text = "No Offline Packs Saved"
                cell.textLabel?.textColor = .darkGray
                cell.textLabel?.textAlignment = .center

            }

            return cell

        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRegion = regionArray[indexPath.row]
            mapView.setVisibleCoordinateBounds(selectedRegion.bounds, animated: true)
        }

        @objc func startOfflinePackDownload() {

            // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
            // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
            let region = MGLTilePyramidOfflineRegion(styleURL: mapView.styleURL, bounds: mapView.visibleCoordinateBounds, fromZoomLevel: mapView.zoomLevel, toZoomLevel: 14)

            // Store some data for identification purposes alongside the downloaded resources.

            let userInfo = ["name": "Region " + "\(regionCount)"]
            let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)

            // Create and register an offline pack with the shared offline storage object.

            MGLOfflineStorage.shared.addPack(for: region, withContext: context) { [self] (pack, error) in
                guard error == nil else {
                    // The pack couldn’t be created for some reason.
                    print("Error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                self.packArray.append(pack!)
                self.regionArray.append(region)
                self.regionCount += 1

                // Start downloading.

                pack!.resume()

            }
        }

        // MARK: - MGLOfflinePack notification handlers

        @objc func offlinePackProgressDidChange(notification: NSNotification) {

            // Get the offline pack this notification is regarding,
            // and the associated user info for the pack; in this case, `name = My Offline Pack`
            if let pack = notification.object as? MGLOfflinePack,
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
                let progress = pack.progress
                // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
                let completedResources = progress.countOfResourcesCompleted
                let expectedResources = progress.countOfResourcesExpected

                // Calculate current progress percentage.

                progressPercentage = Float(completedResources) / Float(expectedResources)

                if completedResources == expectedResources {

                    let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)

                    print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")

                } else {

                    // Otherwise, print download/verification progress.

                    print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(String(format: "%.2f", progressPercentage! * 100))%.")

                }

                self.tableView.reloadData()

            }

        }

        @objc func offlinePackDidReceiveError(notification: NSNotification) {
            if let pack = notification.object as? MGLOfflinePack,
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
                let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
                print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")

            }

        }

        @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
            if let pack = notification.object as? MGLOfflinePack,
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
                let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
                print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")

            }

        }

    }
