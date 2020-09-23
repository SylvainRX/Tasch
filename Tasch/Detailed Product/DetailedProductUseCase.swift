import Foundation
import FoundationExtensions

public protocol DetailedProductUseCase: AnyObject {
  var observer: DetailedProductUseCaseObserver? { get set }

  func updateDetailedProduct()
  func addToWishList()
  func removeFromWishList()
}

public protocol DetailedProductUseCaseObserver: AnyObject {
  func updateState(_ state: DetailedProductUseCaseState)
}

public enum DetailedProductUseCaseState: Equatable {
  case loading
  case detailedProduct(DetailedProduct)
  case addedToWishList
  case removedFromWishList
  case error(Tasch.Error)
}

public class DetailedProductUseCaseImp: DetailedProductUseCase {
  public weak var observer: DetailedProductUseCaseObserver? {
    didSet { updateObserver() }
  }

  private let productId: Int
  private let dataLayer: DataLayer
  private var state: DetailedProductUseCaseState = .loading {
    didSet { updateObserver() }
  }

  public init(productId: Int, dataLayer: DataLayer) {
    self.productId = productId
    self.dataLayer = dataLayer
    updateDetailedProduct()
  }

  public func updateDetailedProduct() {
    state = .loading
    dataLayer.detailedProduct(withId: productId) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(detailedProduct):
        self.state = .detailedProduct(detailedProduct)
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  public func addToWishList() {
    state = .loading
    dataLayer.addToWishList(itemWithId: productId) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.state = .addedToWishList
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  public func removeFromWishList() {
    state = .loading
    dataLayer.removeFromWishList(itemWithId: productId) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        self.state = .removedFromWishList
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  private func updateObserver() {
    observer?.updateState(state)
  }
}
