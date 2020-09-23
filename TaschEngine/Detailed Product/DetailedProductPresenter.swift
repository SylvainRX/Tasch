import Foundation
import Resolver
import Tasch

class DetailedProductPresenter {
  weak var view: DetailedProductView? {
    didSet { updateView() }
  }

  private let router: DetailedProductRouter
  private var useCase: Tasch.DetailedProductUseCase
  private var state: Tasch.DetailedProductUseCaseState = .loading {
    didSet { updateView() }
  }

  init(router: DetailedProductRouter, useCase: Tasch.DetailedProductUseCase) {
    self.router = router
    self.useCase = useCase
    useCase.observer = self
  }

  func refreshDetailedProduct() {
    useCase.updateDetailedProduct()
  }

  func addToWishList() {
    useCase.addToWishList()
  }

  func removeFromWishList() {
    useCase.removeFromWishList()
  }

  private func updateView() {
    guard let view = view else { return }
    switch state {
    case .loading:
      view.updateState(.loading)
    case let .detailedProduct(taschDetailedProduct):
      updateViewFor(taschDetailedProduct: taschDetailedProduct)
    case .addedToWishList:
      router.finish()
    case .removedFromWishList:
      router.finish()
    case let .error(error):
      view.updateState(.error(ErrorDescription(taschError: error)))
    }
  }

  private func updateViewFor(taschDetailedProduct: Tasch.DetailedProduct) {
    guard let view = view else { return }
    guard let model = DetailedProduct.Model(taschDetailedProduct: taschDetailedProduct) else {
      view.updateState(.error(.init(taschError: .dataDecoding)))
      return
    }
    view.updateState(.detailedProduct(model))
  }
}

// MARK: - DetailedProductUseCaseObserver
extension DetailedProductPresenter: DetailedProductUseCaseObserver {

  func updateState(_ state: DetailedProductUseCaseState) {
    self.state = state
  }
}

// MARK: - Model Factories
extension DetailedProduct.Model {

  fileprivate init?(taschDetailedProduct: Tasch.DetailedProduct) {
    guard let imageName = taschDetailedProduct.imageName,
      let cost = taschDetailedProduct.cost,
      let description = taschDetailedProduct.description
    else { return nil }

    let localization: Localization = Resolver.resolve()

    let height: String? = {
      guard let taschHeight = taschDetailedProduct.dimensions[.height] else { return nil }
      return localization.for("product_detail.height.label")
        + ": " + String(taschHeight.centimeters) + "cm/" + String(taschHeight.inches) + "\""
    }()
    let width: String? = {
      guard let taschWidth = taschDetailedProduct.dimensions[.width] else { return nil }
      return localization.for("product_detail.width.label")
        + ": " + String(taschWidth.centimeters) + "cm/" + String(taschWidth.inches) + "\""
    }()
    let depth: String? = {
      guard let taschDepth = taschDetailedProduct.dimensions[.depth] else { return nil }
      return localization.for("product_detail.depth.label")
        + ": " + String(taschDepth.centimeters) + "cm/" + String(taschDepth.inches) + "\""
    }()
    let dimensionsValue = [height, width, depth].compactMap({ $0 }).joined(separator: "\n")

    self.init(id: taschDetailedProduct.id,
              imageName: imageName,
              cost: localization.format(currency: cost),
              description: description,
              availableColors: taschDetailedProduct.availableColors,
              dimensionsValue: dimensionsValue,
              isInWishList: taschDetailedProduct.isInWishList ?? false)
  }
}
