import Foundation

protocol WishListView: AnyObject {
  func updateState(_ state: WishList.ViewState)
}

protocol WishListRouter: AnyObject {
  func routeToItemDetail(itemId: Int, name: String)
}

enum WishList {

  struct Model: Equatable {
    let id: Int
    let name: String
    let imageName: String
    let cost: String
    let description: String
    let availableColors: [String]
    let isOutOfStock: Bool
  }

  enum ViewState: Equatable {
    case loading
    case wishList([Model])
    case error(ErrorDescription)
  }
}
