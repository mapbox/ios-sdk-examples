import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    var example: Example? {
        didSet {
            setupViews()
        }
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        stackView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .medium)
        label.text = self.example?.title ?? "Example" // TODO: Fail better when there is no title
        label.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        if let image = UIImage(named: "sample-example-img") {
            imageView.image = image
        } else {
            print("Couldn't find image") // TODO: Fail better when there is no image
        }
        imageView.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame

        contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addSubview(imageView)
        setupLayout(for: stackView, titleLabel: titleLabel, imageView: imageView)
    }

    private func setupLayout(for stackView: UIStackView, titleLabel: UILabel, imageView: UIImageView) {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
