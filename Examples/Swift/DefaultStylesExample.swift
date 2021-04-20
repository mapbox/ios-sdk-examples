import Mapbox
import UIKit
import MapKit

@objc(DefaultStylesExample_Swift)

class DefaultStylesExample_Swift: UIViewController {

    internal var mapView: MGLMapView!
    internal var startTime: CFAbsoluteTime?
    private var metaView: MapMetaView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime = CFAbsoluteTimeGetCurrent()
        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.streetsStyleURL)
        // Tint the ℹ️ button and the user location annotation.
        mapView.tintColor = .darkGray

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 35.655238, longitude: 139.709769), animated: false)
        mapView.setZoomLevel(15, animated: false)
        mapView.delegate = self

        view.addSubview(mapView)
        metaView = MapMetaView()
        metaView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(metaView!)
        
        NSLayoutConstraint.activate([
            metaView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            metaView!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            metaView!.widthAnchor.constraint(equalToConstant: 200),
            metaView!.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}


extension DefaultStylesExample_Swift: MGLMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        guard fullyRendered else {
            return
        }
        guard let start = startTime else {
            return
        }
        let timeElapsed = CFAbsoluteTimeGetCurrent() - start
        print(Double(timeElapsed))
        metaView?.set(diff: timeElapsed)
    }
}


public class MapMetaView: UIView {
    private var latlngzLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.textColor = .black
        return view
    }()
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .lightGray
        addSubview(latlngzLabel)
        NSLayoutConstraint.activate([
            latlngzLabel.topAnchor.constraint(equalTo: topAnchor),
            latlngzLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            latlngzLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            latlngzLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    public func set(diff: CFAbsoluteTime) {
        let diff = String(format: "%.7f", diff)
        latlngzLabel.text = "Diff: \(diff)"
    }
}


