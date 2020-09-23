import Foundation

protocol CartView: AnyObject {
  func updateState(_ state: Cart.ViewState)
}

enum Cart {

  struct Model: Equatable {
    let totalCost: String
  }

  enum ViewState: Equatable {
    case loading
    case emptyCart
    case cart(Model)
    case checkedOut
    case error(ErrorDescription)
  }
}
