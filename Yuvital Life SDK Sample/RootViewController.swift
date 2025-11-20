import UIKit
import YuvitalLifeSDK
import ReactBrownfield

private struct YuvitalCardConfig {
    let title: String
    let imageName: String
    let isPrimary: Bool
    let isClickable: Bool
}

final class RootViewController: UIViewController {

    private let cards: [YuvitalCardConfig] = [
        .init(
            title: "Open Yuvital Life",
            imageName: "yuvital_life",
            isPrimary: true,
            isClickable: true
        ),
        .init(title: "Heart rate", imageName: "heart_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Nutrition", imageName: "nutrition_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Sleep", imageName: "sleep_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Mindfulness", imageName: "mindfulness_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Walking", imageName: "walking_metric_icon", isPrimary: false, isClickable: false)
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(YuvitalCardCell.self, forCellWithReuseIdentifier: YuvitalCardCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RootViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YuvitalCardCell.reuseIdentifier,
            for: indexPath
        ) as? YuvitalCardCell else {
            return UICollectionViewCell()
        }

        let card = cards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
}

extension RootViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 100, height: 100)
        }

        let totalHorizontalInset = layout.sectionInset.left + layout.sectionInset.right
        let totalSpacing = layout.minimumInteritemSpacing
        let availableWidth = collectionView.bounds.width - totalHorizontalInset - totalSpacing
        let itemWidth = floor(availableWidth / 2)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.item]
        guard card.isClickable else { return }

        let vc = ReactNativeViewController(moduleName: "YuvitalLifeNativeSdk")        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}

private final class YuvitalCardCell: UICollectionViewCell {
    static let reuseIdentifier = "YuvitalCardCell"

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.backgroundColor = .clear

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 18
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 44),
            imageView.heightAnchor.constraint(equalToConstant: 44),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with config: YuvitalCardConfig) {
        containerView.backgroundColor = config.isPrimary ? .primaryCard : .secondaryCard
        imageView.image = UIImage(named: config.imageName)
        titleLabel.text = config.title
        isUserInteractionEnabled = config.isClickable
    }

    override var isHighlighted: Bool {
        didSet {
            let scale: CGFloat = isHighlighted ? 0.96 : 1.0
            let alpha: CGFloat = isHighlighted ? 0.8 : 1.0

            UIView.animate(
                withDuration: 0.12,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]
            ) {
                self.containerView.transform = CGAffineTransform(scaleX: scale, y: scale)
                self.containerView.alpha = alpha
            }
        }
    }
}

private extension UIColor {
    static let primaryCard = UIColor(red: 0.40, green: 0.45, blue: 0.88, alpha: 1.0)
    static let secondaryCard = UIColor(red: 0.09, green: 0.09, blue: 0.12, alpha: 1.0)
}


