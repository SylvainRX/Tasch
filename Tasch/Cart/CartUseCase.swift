import Foundation

public protocol CartUseCase: AnyObject {
  var observer: CartUseCaseObserver? { get set }

  func updateCart()
  func checkOut()
}

public protocol CartUseCaseObserver: AnyObject {
  func updateState(_ state: CartUseCaseState)
}

public enum CartUseCaseState: Equatable {
  case loading
  case cart(Cart)
  case checkedOut
  case error(Tasch.Error)
}

public class CartUseCaseImp: CartUseCase {
  public weak var observer: CartUseCaseObserver? {
    didSet { updateObserver() }
  }

  private var notificationToken: Any?
  private let dataLayer: DataLayer
  private var state: CartUseCaseState = .loading {
    didSet { updateObserver() }
  }

  public init(dataLayer: DataLayer) {
    self.dataLayer = dataLayer
    notificationToken = NotificationCenter.default
      .addObserver(forName: .wishListDidChange,
                   object: nil,
                   queue: nil,
                   using: { [weak self] _ in self?.updateCart() })
    updateCart()
  }

  public func updateCart() {
    self.state = .loading
    dataLayer.userCart { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(cart):
        self.state = .cart(cart)
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  public func checkOut() {
    self.state = .loading
    dataLayer.checkOut() { [weak self] result in
    guard let self = self else { return }
      switch result {
      case .success:
        self.state = .checkedOut
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  private func updateObserver() {
    observer?.updateState(state)
  }
}
