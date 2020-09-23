import Foundation

protocol ProductCatalogueView: AnyObject {
  func updateState(_ state: ProductCatalogue.ViewState)
}

protocol ProductCatalogueRouter: AnyObject {
  func routeToProductDetail(productId: Int, name: String)
}

enum ProductCatalogue {

  struct Model: Equatable {
    let id: Int
    let name: String
    let imageName: String
  }

  enum ViewState: Equatable {
    case loading
    case productCatalogue([Model])
    case error(ErrorDescription)
  }
}
