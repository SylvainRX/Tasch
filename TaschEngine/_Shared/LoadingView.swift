import UIKit
import Resolver

class LoadingView: UIView {

  class func make(activityIndicatorStyle: UIActivityIndicatorView.Style = .white) -> LoadingView {
    let loadingView = LoadingView()
    loadingView.activityIndicator = UIActivityIndicatorView(style: activityIndicatorStyle)
    loadingView.setUp()
    return loadingView
  }

  private var activityIndicator: UIActivityIndicatorView!

  private func setUp() {
    let colorTheme: ColorTheme = Resolver.resolve()
    backgroundColor = colorTheme.firstLevelBackground.withAlphaComponent(0.3)
    addFillerSubview(activityIndicator)
    activityIndicator.startAnimating()
  }
}
