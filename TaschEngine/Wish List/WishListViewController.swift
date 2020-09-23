import Foundation
import Resolver
import Tasch
import UIKit

class WishListViewController: UIViewController {

  class func make() -> WishListViewController {
    let viewController = WishListViewController()
    let dataLayer: Tasch.DataLayer = Resolver.resolve()
    let router = WishListRouterImp(wishListViewController: viewController)
    let useCase = Tasch.WishListUseCaseImp(dataLayer: dataLayer)
    let presenter = WishListPresenter(router: router, useCase: useCase)
    presenter.view = viewController
    viewController.presenter = presenter
    return viewController
  }

  private var colorTheme: ColorTheme = Resolver.resolve()
  private var presenter: WishListPresenter!
  private var state: WishList.ViewState = .loading {
    didSet { updateForCurrentState() }
  }

  private var models: [WishList.Model] {
    guard case let .wishList(models) = state else { return [] }
    return models
  }

  private var loadingView: UIView?
  private var errorView: UIView?
  private var stackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpView()
    updateForCurrentState()
  }

  private func setUpView() {
    view.backgroundColor = colorTheme.secondLevelBackground
    stackView.axis = .vertical
    stackView.spacing = 10
    view.addFillerSubview(stackView)
  }

  private func updateForCurrentState() {
    guard isViewLoaded else { return }
    showNeutralState()
    switch state {
    case .loading:
      showLoading()
    case .wishList:
      updateWishListView()
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
    loadingView?.backgroundColor = colorTheme.secondLevelBackground
    view.addFillerSubview(loadingView!)
  }

  private func hideLoading() {
    loadingView?.removeFromSuperview()
    loadingView = nil
  }

  private func updateWishListView() {
    stackView.removeArrangedSubviews()
    models.forEach { model in
      let wishListItemView = WishListItemView.make(withModel: model)
      wishListItemView.action = { [weak self] in self?.presenter.showDetailForItem(withId: model.id) }
      stackView.addArrangedSubview(wishListItemView)
    }
  }

  private func showError(_ error: ErrorDescription) {
    stackView.removeArrangedSubviews()
    let localization: Localization = Resolver.resolve()
    let messageView = MessageView.make(message: "\(error.title):\n\(error.message)",
                                       actionTitle: localization.for("wish_list.error.reload.action"),
                                       action: { [weak self] in self?.presenter.refreshWishList() })
    view.addFillerSubview(messageView, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    errorView = messageView
  }

  private func hideError() {
    errorView?.removeFromSuperview()
    errorView = nil
  }
}

// MARK: - WishListView
extension WishListViewController: WishListView {

  func updateState(_ state: WishList.ViewState) {
    self.state = state
  }
}
