import UIKit

class ProductCatalogueRouterImp: ProductCatalogueRouter {
  private let productCatalogueViewController: UIViewController
  private var navigationController: UINavigationController? {
    return productCatalogueViewController.navigationController
  }

  init(productCatalogueViewController: UIViewController) {
    self.productCatalogueViewController = productCatalogueViewController
  }

  func routeToProductDetail(productId: Int, name: String) {
    let viewController = DetailedProductViewController.make(forProductWithId: productId, andName: name)
    navigationController?.pushViewController(viewController, animated: true)
  }
}

