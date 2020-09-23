import UIKit
import Resolver

// MARK: - Hierarchy
extension UIView {

  /// Add a subview and constraint to fill the view
  /// - parameter subview: The view to add to self
  /// - parameter insets: Insets to apply between the subview and self
  public func addFillerSubview(_ subview: UIView, insets: UIEdgeInsets = .zero) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      subview.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
      subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
      subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
    ])
  }

  /// Add a subview and constraint to fill the view within its margins
  /// - parameter subview: The view to add to self
  /// - parameter insets: Insets to apply between the subview and self
  public func addMarginFillerSubview(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      subview.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
      subview.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
      subview.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      subview.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
  }
}

// MARK: - Style
extension UIView {
  enum Style {
    case card
  }

  func applyViewStyle(_ style: Style) {
    switch style {
    case .card:
      applyCardStyle()
    }
  }

  private func applyCardStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    backgroundColor = colorTheme.cardBackground
    layer.cornerRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 1.5)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 2
    layer.masksToBounds = false
  }
}
