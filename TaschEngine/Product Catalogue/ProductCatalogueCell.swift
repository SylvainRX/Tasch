import UIKit

class ProductCatalogueCell: UICollectionViewCell {

  static var identifier = "ProductCatalogueCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var model: ProductCatalogue.Model? {
    didSet { updateForCurrentModel() }
  }

  private var imageView = UIImageView()
  private var nameLabel = UILabel()

  private func setUpView() {
    let cardView = UIView()
    cardView.applyViewStyle(.card)
    cardView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    contentView.addFillerSubview(cardView, insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))

    imageView.contentMode = .scaleAspectFit
    cardView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor),
      imageView.topAnchor.constraint(equalTo: cardView.layoutMarginsGuide.topAnchor),
    ])

    nameLabel.applyLabelStyle(.discreteTitle)
    nameLabel.textAlignment = .center
    cardView.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor),
      nameLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor),
      nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
      nameLabel.bottomAnchor.constraint(equalTo: cardView.layoutMarginsGuide.bottomAnchor),
      nameLabel.heightAnchor.constraint(equalToConstant: 15),
    ])
  }

  private func updateForCurrentModel() {
    imageView.image = UIImage(localImageFileName: model?.imageName)
    nameLabel.text = model?.name
  }
}
