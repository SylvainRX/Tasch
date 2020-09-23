import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  @available(iOS 13.0, *)
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene)
      else { return }
    let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window = window
    window.windowScene = windowScene
    StartupFactory().startApp(window: window)
  }
}
