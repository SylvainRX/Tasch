import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if #available(iOS 13.0, *) { return true }
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    StartupFactory().startApp(window: window)
    return true
  }
}
