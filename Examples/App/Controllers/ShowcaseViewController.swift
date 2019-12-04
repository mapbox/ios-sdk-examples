import UIKit

class ShowcaseViewController: UIViewController {

    let allExamples = TestData.allExamples
    var collectionView: UICollectionView!
    var layout = UICollectionViewFlowLayout()

    private let edgeInset: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let headerView = HeaderView(title: "Showcase")
        view.addSubview(containerView)
        containerView.addSubview(headerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edgeInset),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: edgeInset),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInset),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInset),

            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.heightAnchor.constraint(lessThanOrEqualToConstant: 40.0)
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
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
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

        // For compact layouts, display one cell in each row.
        // Example devices with compact layouts:
        //   - iPhone 11 Pro (portrait, landscape)
        //   - iPhone 11 Pro max (portrait)
        var cellWidth = collectionView.frame.width.rounded()

        if (self.traitCollection.horizontalSizeClass == .regular) {
            // For wider layouts, display two cells in each row.
            // Example devices with regular (wider) layouts:
            //   - iPhone 11 Pro max (portrait)
            //   - iPad Pro (12.9") (portrait, landscape)
            cellWidth = ((collectionView.frame.width / 2) - layout.minimumInteritemSpacing).rounded()
        }

        // 3:2 aspect ratio
        let cellHeight = (cellWidth * 0.33).rounded()

        return CGSize(width: cellWidth, height: cellHeight)
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
