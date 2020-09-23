import Resolver
import UIKit

class NavigationController: UINavigationController {
  private let colorTheme: ColorTheme = Resolver.resolve()

  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

  override func viewDidLoad() {
    super.viewDidLoad()
    hideNavigationBarBackButtonText()
    setNavigationBarColor()
    setNavigationBarTitleFont()
    setNavigationBarShadow()
  }

  private func setNavigationBarColor() {
    navigationBar.barTintColor = colorTheme.navigationBackground
    navigationBar.tintColor = colorTheme.navigationText
    navigationBar.isTranslucent = false
  }

  private func hideNavigationBarBackButtonText() {
    let barButtonItemAppearance = UIBarButtonItem.appearance()
    let attributes = [
      NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 0.1)!,
      NSAttributedString.Key.foregroundColor: UIColor.clear,
    ]
    barButtonItemAppearance.setTitleTextAttributes(attributes, for: .normal)
    barButtonItemAppearance.setTitleTextAttributes(attributes, for: .highlighted)
  }

  private func setNavigationBarTitleFont() {
    let attributes = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .regular),
      NSAttributedString.Key.foregroundColor: colorTheme.navigationText,
    ]
    UINavigationBar.appearance().titleTextAttributes = attributes
  }

  private func setNavigationBarShadow() {
    navigationBar.layer.masksToBounds = false
    navigationBar.layer.shadowColor = colorTheme.shadow.cgColor
    navigationBar.layer.shadowOpacity = 0.2
    navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    navigationBar.layer.shadowRadius = 4
  }
}
