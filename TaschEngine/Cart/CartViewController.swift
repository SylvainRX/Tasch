import Foundation
import Resolver
import Tasch
import UIKit

class CartViewController: UIViewController {

  class func make() -> CartViewController {
    let viewController = CartViewController()
    let dataLayer: Tasch.DataLayer = Resolver.resolve()
    let useCase = Tasch.CartUseCaseImp(dataLayer: dataLayer)
    let presenter = CartPresenter(useCase: useCase)
    presenter.view = viewController
    viewController.presenter = presenter
    return viewController
  }

  private var colorTheme: ColorTheme = Resolver.resolve()
  private var localization: Localization = Resolver.resolve()
  private var wishListViewController = WishListViewController.make()
  private var presenter: CartPresenter!
  private var state: Cart.ViewState = .loading {
    didSet { updateForCurrentState() }
  }

  private var model: Cart.Model? {
    guard case let .cart(model) = state else { return nil }
    return model
  }

  private var loadingView: UIView?
  private var errorView: UIView?
  private var stackView = UIStackView()
  private var totalCostLabel: UILabel!
  private lazy var checkOutView = CartCheckOutView.make(checkOutAction: { [weak self] in self?.checkOut() })
  private var emptyCartLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpView()
    updateForCurrentState()
  }

  private func updateForCurrentState() {
    guard isViewLoaded else { return }
    showNeutralState()
    switch state {
    case .loading:
      showLoading()
    case .cart:
      updateCartView()
    case .emptyCart:
      showEmptyCart()
    case .checkedOut:
      break
    case let .error(error):
      showError(error)
    }
  }

  private func showNeutralState() {
    hideError()
    hideLoading()
  }

  private func showLoading() {
    loadingView = LoadingView.make(activityIndicatorStyle: .gray)
    loadingView?.backgroundColor = colorTheme.secondLevelBackground
    view.addFillerSubview(loadingView!)
  }

  private func hideLoading() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }

  private func updateCartView() {
    checkOutView.isHidden = false
    wishListViewController.view.isHidden = false
    emptyCartLabel.isHidden = true

    totalCostLabel.text = model?.totalCost != nil
      ? localization.for("cart.wish_list.total_cost.label") + " " + model!.totalCost
      : nil
    checkOutView.model = model
  }

  private func showEmptyCart() {
    checkOutView.isHidden = true
    emptyCartLabel.isHidden = false
    totalCostLabel.text = localization.for("cart.wish_list.total_cost.label") + " " + localization.format(currency: 0)
  }

  private func showError(_ error: ErrorDescription) {
    wishListViewController.view.isHidden = true
    checkOutView.isHidden = true
    let localization: Localization = Resolver.resolve()
    let messageView = MessageView.make(message: "\(error.title):\n\(error.message)",
                                       actionTitle: localization.for("cart.error.reload.action"),
                                       action: { [weak self] in self?.presenter.refreshCart() })
    view.addFillerSubview(messageView, insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    errorView = messageView
  }

  private func hideError() {
    errorView?.removeFromSuperview()
    errorView = nil
  }

  private func checkOut() {
    let alert = UIAlertController(title: nil,
                                  message: localization.for("cart.wish_list.check_out.confirmation.message"),
                                  preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: localization.for("cart.wish_list.check_out.confirmation.validate.action"),
                                  style: .default,
                                  handler: { [weak self] _ in self?.presenter.checkOut() }))
    alert.addAction(UIAlertAction(title: localization.for("cart.wish_list.check_out.confirmation.cancel.action"),
                                  style: .cancel,
                                  handler: nil))
    present(alert, animated: true)
  }
}

// MARK: - View Set Up
extension CartViewController {

  private func setUpView() {
    view.backgroundColor = colorTheme.secondLevelBackground
    stackView.axis = .vertical
    stackView.spacing = 5
    view.addFillerSubview(stackView, insets: UIEdgeInsets(top: 10, left: 11, bottom: 10, right: 11))

    stackView.addArrangedSubview(makeHeaderView())
    addChild(wishListViewController)
    stackView.addArrangedSubview(wishListViewController.view)
    stackView.addArrangedSubview(makeHorizontalSeparator())
    stackView.addArrangedSubview(checkOutView)
    checkOutView.isHidden = true
    stackView.addArrangedSubview(makeEmptyCartLabel())
  }

  private func makeHeaderView() -> UIView {
    let localization: Localization = Resolver.resolve()
    let headerView = UIView()
    headerView.layoutMargins = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 10)

    let wishListLabel = UILabel()
    wishListLabel.text = localization.for("cart.wish_list.title")
    wishListLabel.textColor = colorTheme.textDefault
    wishListLabel.font = .systemFont(ofSize: 16, weight: .medium)
    wishListLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    wishListLabel.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(wishListLabel)
    NSLayoutConstraint.activate([
      wishListLabel.leftAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leftAnchor),
      wishListLabel.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor),
      wishListLabel.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor),
    ])

    let totalCostLabel = UILabel()
    totalCostLabel.applyLabelStyle(.smallPriceTag)
    totalCostLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(totalCostLabel)
    NSLayoutConstraint.activate([
      totalCostLabel.leftAnchor.constraint(greaterThanOrEqualTo: wishListLabel.leftAnchor, constant: 10),
      totalCostLabel.rightAnchor.constraint(equalTo: headerView.layoutMarginsGuide.rightAnchor),
      totalCostLabel.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor),
      totalCostLabel.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor),
    ])
    self.totalCostLabel = totalCostLabel

    return headerView
  }

  private func makeHorizontalSeparator() -> UIView {
    let separator = UIView()
    separator.backgroundColor = colorTheme.cardBackground
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    let separatorContainer = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    separatorContainer.addFillerSubview(separator, insets: UIEdgeInsets(top: 10, left: 3, bottom: 5, right: 3))
    return separatorContainer
  }

  private func makeEmptyCartLabel() -> UIView {
    emptyCartLabel.applyLabelStyle(.discreteMessage)
    emptyCartLabel.numberOfLines = 0
    emptyCartLabel.lineBreakMode = .byWordWrapping
    emptyCartLabel.text = localization.for("cart.empty_cart.message")
    emptyCartLabel.textAlignment = .center
    return emptyCartLabel
  }
}

// MARK: - CartView
extension CartViewController: CartView {

  func updateState(_ state: Cart.ViewState) {
    self.state = state
  }
}
