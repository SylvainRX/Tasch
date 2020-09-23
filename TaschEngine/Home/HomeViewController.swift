import Resolver
import UIKit

class HomeViewController: UIViewController {
  private let colorTheme: ColorTheme = Resolver.resolve()
  private let localization: Localization = Resolver.resolve()

  private var productCatalogueViewController = ProductCatalogueViewController.make()
  private var cartViewController = CartViewController.make()
  private let stackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setScrollableStackView()
    setTaschNavigationBarLabel()
    setProductCatalogue()
    setCart()
    setColorTheme()
  }
}

// MARK: - View setup
extension HomeViewController {

  private func setScrollableStackView() {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    view.addFillerSubview(scrollView)
    scrollView.addFillerSubview(stackView)
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    stackView.axis = .vertical
  }

  private func setTaschNavigationBarLabel() {
    let taschLabel = UILabel()
    taschLabel.font = .systemFont(ofSize: 27, weight: .heavy)
    taschLabel.text = localization.for("home_screen.title")
    taschLabel.textColor = colorTheme.navigationText
    navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: taschLabel)]
  }

  private func setColorTheme() {
    view.backgroundColor = colorTheme.firstLevelBackground
  }

  private func setProductCatalogue() {
    let containerView = UIView()
    containerView.backgroundColor = colorTheme.firstLevelBackground
    containerView.layoutMargins = UIEdgeInsets(top: 22.5, left: 20, bottom: 20, right: 20)
    let label = UILabel()
    label.textColor = colorTheme.textDefault
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.text = localization.for("home_screen.product_catalogue.title")

    containerView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leftAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leftAnchor),
      label.rightAnchor.constraint(equalTo: containerView.layoutMarginsGuide.rightAnchor),
      label.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor),
    ])

    addChild(productCatalogueViewController)
    let productCatalogueView: UIView! = productCatalogueViewController.view
    containerView.addSubview(productCatalogueView)
    productCatalogueView?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      productCatalogueView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
      productCatalogueView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
      productCatalogueView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12.5),
      productCatalogueView.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor),
      productCatalogueView.heightAnchor.constraint(equalToConstant: 125),
    ])

    stackView.addArrangedSubview(containerView)
  }

  private func setCart() {
    addChild(cartViewController)
    stackView.addArrangedSubview(cartViewController.view)
  }
}
