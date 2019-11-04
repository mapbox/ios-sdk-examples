import UIKit

class ShowcaseViewController: UIViewController {

    let allExamples = TestData.allExamples
    var collectionView: UICollectionView!
    var layout = UICollectionViewFlowLayout()

    private let edgeInset: CGFloat = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let logoImageView = UIImageView(image: UIImage(named: "mapbox-logo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleFont = UIFont.systemFont(ofSize: 34.0, weight: .medium)
        titleLabel.font = titleFont
        titleLabel.text = "Examples" // TODO - Localize titleLabel text

        view.addSubview(containerView)
        headerView.addSubview(logoImageView)
        containerView.addSubview(headerView)
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edgeInset),
//            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: edgeInset),
//            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInset),
//            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInset),

            containerView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: edgeInset),
            containerView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: edgeInset),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInset),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgeInset),

            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 80.0),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            logoImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            logoImageView.widthAnchor.constraint(equalTo: headerView.heightAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: edgeInset)
         ])

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = view.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "ExampleCell")

        containerView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: edgeInset),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout.invalidateLayout()
    }
}

extension ShowcaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allExamples[section].examples.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let exampleGroup = allExamples[indexPath.section]
        let example = exampleGroup.examples[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: indexPath) as! CustomCollectionViewCell

        if cell.example == nil {
            cell.example = example
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allExamples.count
    }
}

extension ShowcaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Use a three column layout for big screen spaces.
        if (UIScreen.main.traitCollection.horizontalSizeClass == .regular) {
            // The 20 value accounts for minimumInterItemSpacing (10pts) between three columns
            return CGSize(width: (collectionView.frame.width - 20) / 3, height: 140)
        }

        // Otherwise use a one-column layout, like a table view.
        return CGSize(width: (collectionView.frame.width), height: 140)
    }
}

//func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    allExamples[section].groupTitle
//}
//
//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    let exampleGroup = allExamples[indexPath.section]
//    var example = exampleGroup.examples[indexPath.row]
//
//    let viewControllerToPresent = example.viewController
//
//    print("Selected example")
//}
