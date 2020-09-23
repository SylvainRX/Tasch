import Foundation
import Resolver
import Tasch

class CartPresenter {
  weak var view: CartView? {
    didSet { updateView() }
  }

  private var useCase: Tasch.CartUseCase
  private var state: Tasch.CartUseCaseState = .loading {
    didSet { updateView() }
  }

  init(useCase: Tasch.CartUseCase) {
    self.useCase = useCase
    useCase.observer = self
  }

  func refreshCart() {
    useCase.updateCart()
  }

  func checkOut() {
    useCase.checkOut()
  }

  private func updateView() {
    guard let view = view else { return }
    switch state {
    case .loading:
      view.updateState(.loading)
    case let .cart(cart):
      updateViewWith(cart: cart)
    case .checkedOut:
      view.updateState(.checkedOut)
    case let .error(error):
      view.updateState(.error(ErrorDescription(taschError: error)))
    }
  }

  private func updateViewWith(cart: Tasch.Cart) {
    guard let view = view else { return }
    guard let totalCost = cart.totalCost, totalCost != 0 else {
      view.updateState(.emptyCart)
      return
    }
    let localization: Localization = Resolver.resolve()
    view.updateState(.cart(Cart.Model(totalCost: localization.format(currency: totalCost))))
  }
}

// MARK: - CartUseCaseObserver
extension CartPresenter: CartUseCaseObserver {

  func updateState(_ state: CartUseCaseState) {
    self.state = state
  }
}
