import Foundation
import Tasch

class ProductCataloguePresenter {
  weak var view: ProductCatalogueView? {
    didSet { updateView() }
  }

  private let router: ProductCatalogueRouter
  private var useCase: Tasch.ProductCatalogueUseCase
  private var state: Tasch.ProductCatalogueUseCaseState = .loading {
    didSet { updateView() }
  }

  init(router: ProductCatalogueRouter, useCase: Tasch.ProductCatalogueUseCase) {
    self.router = router
    self.useCase = useCase
    useCase.observer = self
  }

  func showDetailForProduct(withId id: Int) {
    guard case let .productCatalogue(productCatalogueItems) = state,
      let productCatalogueItem = productCatalogueItems.first(where: { $0.id == id })
    else { return }
    router.routeToProductDetail(productId: productCatalogueItem.id, name: productCatalogueItem.name ?? "")
  }

  func refreshCatalogue() {
    useCase.updateCatalogue()
  }

  private func updateView() {
    guard let view = view else { return }
    switch state {
    case .loading:
      view.updateState(.loading)
    case let .productCatalogue(productCatalogueItems):
      let models = productCatalogueItems.compactMap { ProductCatalogue.Model(taschProductCatalogueItem: $0) }
      view.updateState(.productCatalogue(models))
    case let .error(error):
      view.updateState(.error(ErrorDescription(taschError: error)))
    }
  }
}

// MARK: - ProductCatalogueUseCaseObserver
extension ProductCataloguePresenter: ProductCatalogueUseCaseObserver {

  func updateState(_ state: ProductCatalogueUseCaseState) {
    self.state = state
  }
}

// MARK: - Model Factories
extension ProductCatalogue.Model {

  fileprivate init?(taschProductCatalogueItem: Tasch.ProductCatalogueItem) {
    guard let name = taschProductCatalogueItem.name, name.isNotEmpty,
      let imageName = taschProductCatalogueItem.imageName
    else { return nil }

    self.init(id: taschProductCatalogueItem.id, name: name, imageName: imageName)
  }
}
