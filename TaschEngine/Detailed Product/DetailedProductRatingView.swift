import Resolver
import UIKit

class DetailedProductRatingView: UIView {

  class func make() -> DetailedProductRatingView {
    let view = DetailedProductRatingView()
    view.setUpView()
    return view
  }

  private let colorTheme: ColorTheme = Resolver.resolve()
  private let localization: Localization = Resolver.resolve()
  private let ratingScale = RatingScaleView.make()

  private func setUpView() {
    addFillerSubview(makeView())
  }

  private func makeView() -> UIView {
    let cardView = UIView()
    cardView.applyViewStyle(.card)
    cardView.layoutMargins = UIEdgeInsets(top: 15, left: 11, bottom: 15, right: 11)

    let titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.textColor = colorTheme.textDefault
    titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
    titleLabel.text = localization.for("product_detail.rate_product.label")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    cardView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor),
      titleLabel.topAnchor.constraint(equalTo: cardView.layoutMarginsGuide.topAnchor),
      titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.layoutMarginsGuide.bottomAnchor),
      titleLabel.widthAnchor.constraint(equalToConstant: 70),
    ])

    ratingScale.translatesAutoresizingMaskIntoConstraints = false
    cardView.addSubview(ratingScale)
    NSLayoutConstraint.activate([
      ratingScale.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 10),
      ratingScale.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor),
      ratingScale.topAnchor.constraint(greaterThanOrEqualTo: cardView.layoutMarginsGuide.topAnchor),
      ratingScale.bottomAnchor.constraint(lessThanOrEqualTo: cardView.layoutMarginsGuide.bottomAnchor),
      ratingScale.centerYAnchor.constraint(lessThanOrEqualTo: cardView.layoutMarginsGuide.centerYAnchor),
    ])

    return cardView
  }
}

private class RatingScaleView: UIView {

  private class StarView: UIView {
    private let colorTheme: ColorTheme = Resolver.resolve()
    let imageView = UIImageView(image: UIImage(named: "star_icon"))

    weak var previousStarView: StarView?
    weak var nextStarView: StarView?

    class func make() -> StarView {
      let view = StarView()
      view.setUpView()
      return view
    }

    private func setUpView() {
      imageView.tintColor = colorTheme.ratingScaleEmpty
      addFillerSubview(imageView)
      translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        imageView.widthAnchor.constraint(equalToConstant: 30),
        imageView.heightAnchor.constraint(equalToConstant: 30),
      ])
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelect))
      addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func didSelect() {
      select()
      nextStarView?.deselect()
    }

    private func select() {
      imageView.tintColor = colorTheme.ratingScaleFull
      previousStarView?.select()
    }

    private func deselect() {
      imageView.tintColor = colorTheme.ratingScaleEmpty
      nextStarView?.deselect()
    }
  }

  class func make() -> RatingScaleView {
    let view = RatingScaleView()
    view.setUpView()
    return view
  }

  private var starViews = [StarView]()

  private func setUpView() {
    let stackView = UIStackView()
    stackView.spacing = 5
    addFillerSubview(stackView)

    (0 ..< 5).forEach { _ in
      let starView = StarView.make()
      starView.previousStarView = starViews.last
      starViews.append(starView)
    }
    var nextStarView: StarView?
    starViews.reversed().forEach { starView in
      starView.nextStarView = nextStarView
      nextStarView = starView
    }

    stackView.addArrangedSubviews(starViews)
  }
}
