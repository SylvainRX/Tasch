import Foundation
import Resolver
import UIKit

class DetailedProductInfoView: UIView {

  class func make() -> DetailedProductInfoView {
    let view = DetailedProductInfoView()
    view.setUpView()
    return view
  }

  var model: DetailedProduct.Model? {
    didSet {
      costLabel.text = model?.cost
      descriptionLabel.text = model?.description
      dimensionsLabel.text = model?.dimensionsValue
      colorsView.colors = model?.availableColors.compactMap { UIColor(hexString: $0) } ?? []
    }
  }

  private let stackView = UIStackView()
  private let costLabel = UILabel()
  private let descriptionLabel = UILabel()
  private let colorsView = ColorsView.make()
  private let dimensionsLabel = UILabel()

  private let colorTheme: ColorTheme = Resolver.resolve()
  private let localization: Localization = Resolver.resolve()

  private func setUpView() {
    applyViewStyle(.card)
    stackView.axis = .vertical
    stackView.spacing = 13
    addFillerSubview(stackView)

    stackView.addArrangedSubview(makeCostView())
    stackView.addArrangedSubview(makeSeparatorView())
    stackView.addArrangedSubview(makeDescriptionView())
    stackView.addArrangedSubview(makeColorsView())
    stackView.addArrangedSubview(makeDimensionsView())
  }

  private func makeCostView() -> UIView {
    let costView = UIView()
    costView.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 0, right: 15)

    costLabel.applyLabelStyle(.bigPriceTag)
    costLabel.translatesAutoresizingMaskIntoConstraints = false
    costView.addSubview(costLabel)
    NSLayoutConstraint.activate([
      costLabel.leftAnchor.constraint(equalTo: costView.layoutMarginsGuide.leftAnchor),
      costLabel.topAnchor.constraint(equalTo: costView.layoutMarginsGuide.topAnchor),
      costLabel.bottomAnchor.constraint(equalTo: costView.layoutMarginsGuide.bottomAnchor),
    ])

    let promotionLabel = UILabel()
    promotionLabel.textColor = colorTheme.promotionText
    promotionLabel.text = localization.for("product_detail.free_shipping_worldwide.message")
    promotionLabel.font = .systemFont(ofSize: 15, weight: .medium)
    promotionLabel.translatesAutoresizingMaskIntoConstraints = false
    costView.addSubview(promotionLabel)
    NSLayoutConstraint.activate([
      promotionLabel.leftAnchor.constraint(equalTo: costLabel.rightAnchor, constant: 14),
      promotionLabel.rightAnchor.constraint(lessThanOrEqualTo: costView.layoutMarginsGuide.rightAnchor),
      promotionLabel.topAnchor.constraint(greaterThanOrEqualTo: costView.layoutMarginsGuide.topAnchor),
      promotionLabel.lastBaselineAnchor.constraint(equalTo: costLabel.firstBaselineAnchor),
    ])
    promotionLabel.numberOfLines = 0
    promotionLabel.lineBreakMode = .byWordWrapping
    promotionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    return costView
  }

  private func makeSeparatorView() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = colorTheme.secondLevelBackground
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    return separatorView
  }

  private func makeDescriptionView() -> UIView {
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.applyLabelStyle(.default)
    let containerView = UIView()
    containerView.layoutMargins = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
    containerView.addMarginFillerSubview(descriptionLabel)
    return containerView
  }

  private func makeColorsView() -> UIView {
    let colorsViewContainer = UIView()
    colorsViewContainer.layoutMargins = UIEdgeInsets(top: 10, left: 11, bottom: 0, right: 11)

    let titleLabel = UILabel()
    titleLabel.textColor = colorTheme.textDefault
    titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
    titleLabel.text = localization.for("product_detail.colors.label")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    colorsViewContainer.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: colorsViewContainer.layoutMarginsGuide.leftAnchor),
      titleLabel.topAnchor.constraint(equalTo: colorsViewContainer.layoutMarginsGuide.topAnchor),
      titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: colorsViewContainer.layoutMarginsGuide.bottomAnchor),
      titleLabel.widthAnchor.constraint(equalToConstant: 70),
    ])

    colorsView.translatesAutoresizingMaskIntoConstraints = false
    colorsViewContainer.addSubview(colorsView)
    NSLayoutConstraint.activate([
      colorsView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10),
      colorsView.rightAnchor.constraint(equalTo: colorsViewContainer.layoutMarginsGuide.rightAnchor),
      colorsView.topAnchor.constraint(equalTo: colorsViewContainer.layoutMarginsGuide.topAnchor),
      colorsView.bottomAnchor.constraint(equalTo: colorsViewContainer.layoutMarginsGuide.bottomAnchor),
    ])

    return colorsViewContainer
  }

  private func makeDimensionsView() -> UIView {
    let sizes = UIView()
    sizes.layoutMargins = UIEdgeInsets(top: 0, left: 11, bottom: 20, right: 11)

    let titleLabel = UILabel()
    titleLabel.textColor = colorTheme.textDefault
    titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
    titleLabel.text = localization.for("product_detail.sizes.label")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    sizes.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: sizes.layoutMarginsGuide.leftAnchor),
      titleLabel.topAnchor.constraint(equalTo: sizes.layoutMarginsGuide.topAnchor),
      titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: sizes.layoutMarginsGuide.bottomAnchor),
      titleLabel.widthAnchor.constraint(equalToConstant: 70),
    ])

    dimensionsLabel.translatesAutoresizingMaskIntoConstraints = false
    dimensionsLabel.applyLabelStyle(.default)
    dimensionsLabel.numberOfLines = 0
    dimensionsLabel.lineBreakMode = .byWordWrapping
    sizes.addSubview(dimensionsLabel)
    NSLayoutConstraint.activate([
      dimensionsLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10),
      dimensionsLabel.rightAnchor.constraint(equalTo: sizes.layoutMarginsGuide.rightAnchor),
      dimensionsLabel.topAnchor.constraint(equalTo: sizes.layoutMarginsGuide.topAnchor),
      dimensionsLabel.bottomAnchor.constraint(equalTo: sizes.layoutMarginsGuide.bottomAnchor),
    ])

    return sizes
  }
}

/// Goal: Display a line of colored tiles that can wrap into multiple lines if needed
private class ColorsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  class func make() -> ColorsView {
    let view = ColorsView()
    view.setUp()
    return view
  }

  var colors = [UIColor]() {
    didSet { update() }
  }

  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  private var heightConstraint: NSLayoutConstraint!
  private var collectionWidthConstraint: NSLayoutConstraint!
  private let cellSize: CGFloat = 53
  private let spacing: CGFloat = 12

  private func setUp() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "color")
    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = false
    collectionView.sizeToFit()

    heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 70)
    heightConstraint.isActive = true

    collectionWidthConstraint = collectionView.widthAnchor.constraint(equalToConstant: 0)
    collectionWidthConstraint.isActive = true

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  func update() {
    let width = frame.width
    let cellCount = colors.count
    let cellsPerRow = (width / (cellSize + spacing)).rounded(.down)
    let rowCount = (CGFloat(cellCount) / cellsPerRow).rounded(.up)
    heightConstraint.constant = rowCount * (cellSize + spacing)
    collectionWidthConstraint.constant = cellsPerRow * (cellSize + spacing)
    collectionView.reloadData()
    layoutIfNeeded()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath)
    let color = colors.indices.contains(indexPath.row) ? colors[indexPath.row] : nil
    cell.backgroundColor = color
    cell.layer.cornerRadius = 5
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellSize, height: cellSize)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: spacing, right: spacing)
  }
}
