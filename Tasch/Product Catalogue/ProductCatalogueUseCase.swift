import Foundation
import FoundationExtensions

public protocol ProductCatalogueUseCase: AnyObject {
  var observer: ProductCatalogueUseCaseObserver? { get set }

  func updateCatalogue()
}

public protocol ProductCatalogueUseCaseObserver: AnyObject {
  func updateState(_ state: ProductCatalogueUseCaseState)
}

public enum ProductCatalogueUseCaseState: Equatable {
  case loading
  case productCatalogue([ProductCatalogueItem])
  case error(Tasch.Error)
}

public class ProductCatalogueUseCaseImp: ProductCatalogueUseCase {
  public weak var observer: ProductCatalogueUseCaseObserver? {
    didSet { updateObserver() }
  }

  private let dataLayer: DataLayer
  private var state: ProductCatalogueUseCaseState = .loading {
    didSet { updateObserver() }
  }

  public init(dataLayer: DataLayer) {
    self.dataLayer = dataLayer
    updateCatalogue()
  }

  public func updateCatalogue() {
    self.state = .loading
    dataLayer.productCatalogue { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(productCatalogue):
        self.updateStateForCatalogue(productCatalogue)
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  private func updateStateForCatalogue(_ productCatalogue: [ProductCatalogueItem]) {
    guard productCatalogue.isNotEmpty else {
      state = .error(.dataNotFound)
      return
    }
    state = .productCatalogue(productCatalogue)
  }

  private func updateObserver() {
    observer?.updateState(state)
  }
}
