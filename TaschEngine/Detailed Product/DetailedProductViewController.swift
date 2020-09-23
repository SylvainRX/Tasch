import Resolver
import Tasch
import UIKit

class DetailedProductViewController: UIViewController {

  class func make(forProductWithId productId: Int, andName productName: String) -> DetailedProductViewController {
    let viewController = DetailedProductViewController()
    let dataLayer: Tasch.DataLayer = Resolver.resolve()
    let router = DetailedProductRouterImp(detailedProductViewController: viewController)
    let useCase = Tasch.DetailedProductUseCaseImp(productId: productId, dataLayer: dataLayer)
    let presenter = DetailedProductPresenter(router: router, useCase: useCase)
    presenter.view = viewController
    viewController.presenter = presenter
    viewController.title = productName
    return viewController
  }

  private let localization: Localization = Resolver.resolve()
  private var colorTheme: ColorTheme = Resolver.resolve()
  private var presenter: DetailedProductPresenter!
  private var state: DetailedProduct.ViewState = .loading {
    didSet { updateForCurrentState() }
  }

  private var model: DetailedProduct.Model? {
    guard case let .detailedProduct(model) = state else { return nil }
    return model
  }

  private let contentView = UIView()
  private let headerView = UIView()
  private let productImageView = UIImageView()
  private let productInfoView = DetailedProductInfoView.make()
  private let productRatingView = DetailedProductRatingView.make()
  private let wishListButtonsView = UIView()
  private var loadingView: UIView?
  private var errorView: UIView?

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
    case .detailedProduct:
      updateDetailedProductView()
    case let .error(error):
      showError(error)
    }
  }

  private func showNeutralState() {
    hideLoading()
    hideError()
  }

  private func showLoading() {
    loadingView = LoadingView.make(activityIndicatorStyle: .gray)
    loadingView?.backgroundColor = colorTheme.firstLevelBackground
    view.addFillerSubview(loadingView!)
    productInfoView.isHidden = true
    productRatingView.isHidden = true
  }

  private func hideLoading() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }

  private func updateDetailedProductView() {
    productInfoView.isHidden = false
    productRatingView.isHidden = false
    productImageView.image = UIImage(localImageFileName: model?.imageName)
    productInfoView.model = model
    wishListButtonsView.subviews.forEach { $0.removeFromSuperview() }
    if model?.isInWishList ?? false {
      wishListButtonsView.addFillerSubview(makeRemoveFromWishListButton())
    }
    else {
      wishListButtonsView.addFillerSubview(makeAddToWishListButton())
    }
  }

  private func showError(_ error: ErrorDescription) {
    let messageView = MessageView.make(message: "\(error.title):\n\(error.message)",
                                       actionTitle: localization.for("product_detail.error.reload.action"),
                                       action: { [weak self] in self?.presenter.refreshDetailedProduct() })
    view.addFillerSubview(messageView, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    errorView = messageView
  }

  private func hideError() {
    errorView?.removeFromSuperview()
    errorView = nil
  }

  @objc private func addToWishList() {
    presenter.addToWishList()
  }

  @objc private func removeFromWishList() {
    presenter.removeFromWishList()
  }
}

// MARK: View Set Up
extension DetailedProductViewController {

  private func setUpView() {
    view.backgroundColor = colorTheme.secondLevelBackground
    setUpScrollView()
    setUpImageHeader()
    setUpProductInfoView()
    setUpProductRatingView()
    setUpWishListButtonsView()
  }

  private func setUpScrollView() {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    view.addFillerSubview(scrollView)
    scrollView.addFillerSubview(contentView)
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    contentView.layoutMargins = UIEdgeInsets(top: 0, left: 11, bottom: 10, right: 11)
  }

  private func setUpImageHeader() {
    headerView.backgroundColor = colorTheme.cardBackground
    headerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(headerView)
    NSLayoutConstraint.activate([
      headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -500),
      headerView.heightAnchor.constraint(equalToConstant: 280 + 500),
    ])
    headerView.layoutMargins = UIEdgeInsets(top: 10 + 500, left: 11, bottom: 50, right: 11)
    headerView.addMarginFillerSubview(productImageView)

    productImageView.contentMode = .scaleAspectFit
  }

  private func setUpProductInfoView() {
    productInfoView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(productInfoView)
    NSLayoutConstraint.activate([
      productInfoView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
      productInfoView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
      productInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -55),
    ])
  }

  private func setUpProductRatingView() {
    productRatingView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(productRatingView)
    NSLayoutConstraint.activate([
      productRatingView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
      productRatingView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
      productRatingView.topAnchor.constraint(equalTo: productInfoView.bottomAnchor, constant: 7),
    ])
  }

  private func setUpWishListButtonsView() {
    wishListButtonsView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(wishListButtonsView)
    NSLayoutConstraint.activate([
      wishListButtonsView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 12),
      wishListButtonsView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -12),
      wishListButtonsView.topAnchor.constraint(equalTo: productRatingView.bottomAnchor, constant: 15),
      wishListButtonsView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
    ])
  }

  private func makeAddToWishListButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.applyButtonStyle(.enticing)
    button.setTitle(localization.for("product_detail.add_to_wish_list.action"), for: .normal)
    button.addTarget(self, action: #selector(addToWishList), for: .primaryActionTriggered)
    return button
  }

  private func makeRemoveFromWishListButton() -> UIButton {
    let button = UIButton(type: .custom)
    button.applyButtonStyle(.destructive)
    button.setTitle(localization.for("product_detail.remove_from_wish_list.action"), for: .normal)
    button.addTarget(self, action: #selector(removeFromWishList), for: .primaryActionTriggered)
    return button
  }
}

// MARK: - DetailedProductView
extension DetailedProductViewController: DetailedProductView {

  func updateState(_ state: DetailedProduct.ViewState) {
    self.state = state
  }
}
