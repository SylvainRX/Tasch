import Foundation
import Resolver
import Tasch

class WishListPresenter {
  weak var view: WishListView? {
    didSet { updateView() }
  }

  private let router: WishListRouter
  private var useCase: Tasch.WishListUseCase
  private var state: Tasch.WishListUseCaseState = .loading {
    didSet { updateView() }
  }

  init(router: WishListRouter, useCase: Tasch.WishListUseCase) {
    self.router = router
    self.useCase = useCase
    useCase.observer = self
  }

  func showDetailForItem(withId id: Int) {
    guard case let .wishList(wishListItems) = state,
      let wishListItem = wishListItems.first(where: { $0.id == id })
    else { return }
    router.routeToItemDetail(itemId: wishListItem.id, name: wishListItem.name ?? "")
  }

  func refreshWishList() {
    useCase.updateWishList()
  }

  private func updateView() {
    guard let view = view else { return }
    switch state {
    case .loading:
      view.updateState(.loading)
    case let .wishList(wishListItems):
      let models = wishListItems.compactMap { WishList.Model(taschWishListItem: $0) }
      view.updateState(.wishList(models))
    case let .error(error):
      view.updateState(.error(ErrorDescription(taschError: error)))
    }
  }
}

// MARK: - WishListUseCaseObserver
extension WishListPresenter: WishListUseCaseObserver {

  func updateState(_ state: WishListUseCaseState) {
    self.state = state
  }
}

// MARK: - Model Factories
extension WishList.Model {

  fileprivate init?(taschWishListItem: Tasch.WishListItem) {
    guard let name = taschWishListItem.name, name.isNotEmpty,
      let imageName = taschWishListItem.imageName,
      let cost = taschWishListItem.cost,
      let description = taschWishListItem.description
    else { return nil }

    let localization: Localization = Resolver.resolve()
    self.init(id: taschWishListItem.id,
              name: name,
              imageName: imageName,
              cost: localization.format(currency: cost),
              description: description,
              availableColors: taschWishListItem.availableColors,
              isOutOfStock: taschWishListItem.inStockQuantity == 0)
  }
}
