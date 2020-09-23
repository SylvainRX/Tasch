import Resolver
import UIKit

class CartCheckOutView: UIView {

  class func make(checkOutAction: @escaping () -> Void) -> CartCheckOutView {
    let view = CartCheckOutView()
    view.setUpView()
    view.checkOutAction = checkOutAction
    return view
  }

  var model: Cart.Model? {
    didSet {
      totalCostLabel.text = model?.totalCost
    }
  }

  private var checkOutAction: (() -> Void)!
  private var localization: Localization = Resolver.resolve()
  private var colorTheme: ColorTheme = Resolver.resolve()

  private var totalCostLabel = UILabel()

  private func setUpView() {
    backgroundColor = colorTheme.secondLevelBackground
    layoutMargins = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

    let labelsView = UIView()

    let subTotalView = makeSubTotalView()
    subTotalView.translatesAutoresizingMaskIntoConstraints = false
    labelsView.addSubview(subTotalView)
    NSLayoutConstraint.activate([
      subTotalView.leftAnchor.constraint(greaterThanOrEqualTo: labelsView.leftAnchor),
      subTotalView.rightAnchor.constraint(lessThanOrEqualTo: labelsView.rightAnchor),
      subTotalView.centerXAnchor.constraint(equalTo: labelsView.centerXAnchor),
      subTotalView.topAnchor.constraint(equalTo: labelsView.topAnchor),
    ])

    let freeShippingLabel = makeFreeShippingLabel()
    freeShippingLabel.translatesAutoresizingMaskIntoConstraints = false
    labelsView.addSubview(freeShippingLabel)
    NSLayoutConstraint.activate([
      freeShippingLabel.leftAnchor.constraint(greaterThanOrEqualTo: labelsView.leftAnchor),
      freeShippingLabel.rightAnchor.constraint(lessThanOrEqualTo: labelsView.rightAnchor),
      freeShippingLabel.centerXAnchor.constraint(equalTo: labelsView.centerXAnchor),
      freeShippingLabel.topAnchor.constraint(equalTo: subTotalView.bottomAnchor),
      freeShippingLabel.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
    ])

    labelsView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(labelsView)
    NSLayoutConstraint.activate([
      labelsView.leftAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leftAnchor),
      labelsView.rightAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.rightAnchor),
      labelsView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
      labelsView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
    ])

    let checkOutButton = makeCheckOutButton()
    checkOutButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(checkOutButton)
    NSLayoutConstraint.activate([
      checkOutButton.leftAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leftAnchor),
      checkOutButton.rightAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.rightAnchor),
      checkOutButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
      checkOutButton.topAnchor.constraint(equalTo: labelsView.bottomAnchor, constant: 25),
      checkOutButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
  }

  private func makeSubTotalView() -> UIView {
    let subTotalView = UIView()
    let subTotalTitleLabel = UILabel()
    subTotalTitleLabel.textColor = colorTheme.textDefault
    subTotalTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    subTotalTitleLabel.text = localization.for("cart.wish_list.sub_total.label")
    subTotalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subTotalView.addSubview(subTotalTitleLabel)
    NSLayoutConstraint.activate([
      subTotalTitleLabel.leftAnchor.constraint(greaterThanOrEqualTo: subTotalView.leftAnchor),
      subTotalTitleLabel.topAnchor.constraint(equalTo: subTotalView.topAnchor),
      subTotalTitleLabel.bottomAnchor.constraint(equalTo: subTotalView.bottomAnchor),
    ])
    totalCostLabel.textColor = colorTheme.textDefault
    totalCostLabel.font = .systemFont(ofSize: 20, weight: .light)
    totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
    subTotalView.addSubview(totalCostLabel)
    NSLayoutConstraint.activate([
      totalCostLabel.leftAnchor.constraint(equalTo: subTotalTitleLabel.rightAnchor, constant: 3),
      totalCostLabel.rightAnchor.constraint(lessThanOrEqualTo: subTotalView.rightAnchor),
      totalCostLabel.topAnchor.constraint(equalTo: subTotalView.topAnchor),
      totalCostLabel.bottomAnchor.constraint(equalTo: subTotalView.bottomAnchor),
    ])
    return subTotalView
  }

  private func makeFreeShippingLabel() -> UIView {
    let freeShippingLabel = UILabel()
    freeShippingLabel.text = localization.for("cart.wish_list.free_shipping_worldwide.message")
    freeShippingLabel.textColor = colorTheme.promotionText
    freeShippingLabel.font = .systemFont(ofSize: 15, weight: .medium)
    freeShippingLabel.textAlignment = .center
    return freeShippingLabel
  }

  private func makeCheckOutButton() -> UIView {
    let checkOutButton = UIButton(type: .custom)
    checkOutButton.setTitle(localization.for("cart.wish_list.check_out.action"), for: .normal)
    checkOutButton.applyButtonStyle(.enticing)
    checkOutButton.addTarget(self, action: #selector(checkOut), for: .primaryActionTriggered)
    return checkOutButton
  }

  @objc private func checkOut() {
    checkOutAction()
  }
}
