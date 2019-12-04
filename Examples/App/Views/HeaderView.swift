import UIKit

class HeaderView: UIStackView {

    var title: String

    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "mapbox-logo")
        return imageView
    }()

    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
        label.text = self.title // TODO: Localize header title text
        label.sizeToFit()
        return label
    }()

    init(title: String) {
        self.title = title
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = 8.0
        self.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.addArrangedSubview(logoView)
        self.addArrangedSubview(headerLabel)

        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalTo: headerLabel.heightAnchor),
            logoView.widthAnchor.constraint(equalTo: self.heightAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor)
        ])
    }
}
