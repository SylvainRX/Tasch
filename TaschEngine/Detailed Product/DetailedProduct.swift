import Foundation

protocol DetailedProductView: AnyObject {
  func updateState(_ state: DetailedProduct.ViewState)
}

protocol DetailedProductRouter: AnyObject {
  func finish()
}

enum DetailedProduct {

  struct Model: Equatable {
    let id: Int
    let imageName: String
    let cost: String
    let description: String?
    let availableColors: [String]
    let dimensionsValue: String
    let isInWishList: Bool
  }

  enum ViewState: Equatable {
    case loading
    case detailedProduct(Model)
    case error(ErrorDescription)
  }
}
