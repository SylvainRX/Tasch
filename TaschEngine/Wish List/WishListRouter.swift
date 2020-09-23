import UIKit

class WishListRouterImp: WishListRouter {
  private let wishListViewController: UIViewController
  private var navigationController: UINavigationController? {
    return wishListViewController.navigationController
  }

  init(wishListViewController: UIViewController) {
    self.wishListViewController = wishListViewController
  }

  func routeToItemDetail(itemId: Int, name: String) {
    let viewController = DetailedProductViewController.make(forProductWithId: itemId, andName: name)
    navigationController?.pushViewController(viewController, animated: true)
  }
}
