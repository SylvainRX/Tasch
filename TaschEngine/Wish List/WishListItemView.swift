import Resolver
import UIKit

class WishListItemView: UIView {

  class func make(withModel model: WishList.Model) -> WishListItemView {
    let view = WishListItemView()
    view.model = model
    view.setUpView()
    return view
  }

  var action: (() -> Void)?

  private var model: WishList.Model!

  private func setUpView() {
    let cardView = UIView()
    cardView.applyViewStyle(.card)
    addFillerSubview(cardView)

    let horizontalStackView = UIStackView()
    cardView.addFillerSubview(horizontalStackView)

    horizontalStackView.addArrangedSubview(makeImageView())

    let (verticalStackViewContainer, verticalStackView) = makeVerticalStackView()
    horizontalStackView.addArrangedSubview(verticalStackViewContainer)

    verticalStackView.addArrangedSubview(makeCostLabel())
    verticalStackView.addArrangedSubview(makeNameLabel())
    verticalStackView.addArrangedSubview(makeDescriptionLabel())

    if model.isOutOfStock { verticalStackView.addArrangedSubview(makeOutOfStockLabel()) }
    else { verticalStackView.addArrangedSubview(makeColorsView()) }

    horizontalStackView.addArrangedSubview(makeDisclosureView())

    addTapGestureRecognizer()
  }

  private func makeImageView() -> UIView {
    let imageView = UIImageView(image: UIImage(localImageFileName: model.imageName))
    imageView.contentMode = .scaleAspectFit
    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 75),
      imageView.widthAnchor.constraint(equalToConstant: 75),
    ])
    let imageViewContainer = UIView()
    imageViewContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewContainer.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leftAnchor.constraint(equalTo: imageViewContainer.layoutMarginsGuide.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: imageViewContainer.layoutMarginsGuide.rightAnchor),
      imageView.topAnchor.constraint(greaterThanOrEqualTo: imageViewContainer.layoutMarginsGuide.topAnchor),
      imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageViewContainer.layoutMarginsGuide.bottomAnchor),
      imageView.centerYAnchor.constraint(equalTo: imageViewContainer.layoutMarginsGuide.centerYAnchor),
    ])
    return imageViewContainer
  }

  private func makeVerticalStackView() -> (container: UIView, stackView: UIStackView) {
    let verticalStackView = UIStackView()
    verticalStackView.axis = .vertical
    let verticalStackViewContainer = UIView()
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    verticalStackViewContainer.addSubview(verticalStackView)
    NSLayoutConstraint.activate([
      verticalStackView.leftAnchor.constraint(equalTo: verticalStackViewContainer.leftAnchor),
      verticalStackView.rightAnchor.constraint(equalTo: verticalStackViewContainer.rightAnchor),
      verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: verticalStackViewContainer.topAnchor, constant: 10),
      verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: verticalStackViewContainer.bottomAnchor, constant: 10),
      verticalStackView.centerYAnchor.constraint(equalTo: verticalStackViewContainer.centerYAnchor),
    ])
    return (verticalStackViewContainer, verticalStackView)
  }

  private func makeCostLabel() -> UIView {
    let costLabel = UILabel()
    costLabel.applyLabelStyle(.mediumPriceTag)
    costLabel.text = model.cost
    return costLabel
  }

  private func makeNameLabel() -> UIView {
    let nameLabel = UILabel()
    nameLabel.applyLabelStyle(.discreteTitle)
    nameLabel.text = model.name
    nameLabel.numberOfLines = 0
    nameLabel.lineBreakMode = .byWordWrapping
    return nameLabel
  }

  private func makeDescriptionLabel() -> UIView {
    let descriptionLabel = UILabel()
    descriptionLabel.applyLabelStyle(.discreteMessage)
    descriptionLabel.text = model.description
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    return descriptionLabel
  }

  private func makeOutOfStockLabel() -> UIView {
    let localization: Localization = Resolver.resolve()
    let outOfStockLabel = UILabel()
    outOfStockLabel.applyLabelStyle(.warning)
    outOfStockLabel.text = localization.for("wish_list.product_out_of_stock.message")
    return outOfStockLabel
  }

  private func makeColorsView() -> UIView {
    let colorStackView = UIStackView()
    model.availableColors.forEach {
      guard let color = UIColor(hexString: $0) else { return }
      let colorView = UIView()
      colorView.backgroundColor = color
      colorView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        colorView.widthAnchor.constraint(equalToConstant: 25),
        colorView.heightAnchor.constraint(equalToConstant: 25),
      ])
      colorStackView.addArrangedSubview(colorView)
    }
    colorStackView.spacing = 6
    let colorStackViewContainer = UIView()
    colorStackView.translatesAutoresizingMaskIntoConstraints = false
    colorStackViewContainer.addSubview(colorStackView)
    NSLayoutConstraint.activate([
      colorStackView.leftAnchor.constraint(equalTo: colorStackViewContainer.leftAnchor),
      colorStackView.rightAnchor.constraint(lessThanOrEqualTo: colorStackViewContainer.rightAnchor),
      colorStackView.topAnchor.constraint(equalTo: colorStackViewContainer.topAnchor, constant: 8),
      colorStackView.bottomAnchor.constraint(equalTo: colorStackViewContainer.bottomAnchor),
    ])
    return colorStackViewContainer
  }

  private func makeDisclosureView() -> UIView {
    let colorTheme: ColorTheme = Resolver.resolve()
    let disclosureImageView = UIImageView(image: UIImage(named: "disclosure_icon"))
    disclosureImageView.tintColor = colorTheme.textAction
    disclosureImageView.contentMode = .scaleAspectFit
    disclosureImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
    let disclosureImageViewContainer = UIView()
    disclosureImageViewContainer.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    disclosureImageViewContainer.addMarginFillerSubview(disclosureImageView)
    return disclosureImageViewContainer
  }

  private func addTapGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    addGestureRecognizer(tapGestureRecognizer)
  }

  @objc func didTap() {
    action?()
  }
}
