import Mapbox

let oramentPositions: [[MGLOrnamentPosition]] = [
    [.topLeft, .topRight, .bottomRight, .bottomLeft],
    [.topRight, .bottomRight, .bottomLeft, .topLeft],
    [.bottomRight, .bottomLeft, .topLeft, .topRight],
    [.bottomLeft, .topLeft, .topRight, .bottomRight]
]

@objc(OrnamentsLayoutExample_Swift)
class OrnamentsLayoutExample_Swift: UIViewController, MGLMapViewDelegate {
    var mapView: MGLMapView!
    var timer: Timer?
    var currentPositionIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsScale = true
        mapView.setCenter(CLLocationCoordinate2DMake(39.915143, 116.404053), zoomLevel: 16, direction: 30, animated: false)
        self.view.addSubview(mapView)

        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerTick), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        guard let timer = self.timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }

    func updateOrnamentsPosition() {

        let positions = oramentPositions[self.currentPositionIndex%4]
        self.mapView.scaleBarPosition = positions[0]
        self.mapView.compassViewPosition = positions[1]
        self.mapView.logoViewPosition = positions[2]
        self.mapView.attributionButtonPosition = positions[3]
    }

    @objc func onTimerTick() {
        self.currentPositionIndex += 1
        self.updateOrnamentsPosition()
    }
}
