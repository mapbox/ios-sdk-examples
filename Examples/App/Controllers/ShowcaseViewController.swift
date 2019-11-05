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

        let headerView = HeaderView(title: "Examples")
        view.addSubview(containerView)
        containerView.addSubview(headerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edgeInset * 2),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: edgeInset),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInset),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInset),

            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.06)
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
