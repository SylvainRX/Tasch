import UIKit

class DetailedProductRouterImp: DetailedProductRouter {
  private let detailedProductViewController: UIViewController
  private var navigationController: UINavigationController? {
    return detailedProductViewController.navigationController
  }

  init(detailedProductViewController: UIViewController) {
    self.detailedProductViewController = detailedProductViewController
  }

  func finish() {
    navigationController?.popViewController(animated: true)
  }
}
