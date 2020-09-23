import Foundation
import Resolver
import Tasch
import UIKit

class StartupFactory {

  func startApp(window: UIWindow) {
    registerDependencies()
    setupUI(window: window)
  }

  private func registerDependencies() {
    let dataLayer = TaschDataLayer()
    Resolver.register(Tasch.DataLayer.self) { dataLayer }
    Resolver.register(Localization.self) { Localization() }
    Resolver.register(ColorTheme.self) { LightColorTheme() }
  }

  private func setupUI(window: UIWindow) {
    let homeViewController = NavigationController(rootViewController: HomeViewController())
    window.rootViewController = homeViewController
    window.makeKeyAndVisible()
  }
}
