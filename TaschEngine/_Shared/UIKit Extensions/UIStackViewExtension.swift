import UIKit

extension UIStackView {

  /// Add arranged subviews
  func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach { addArrangedSubview($0) }
  }

  /// Remove arranged subviews and remove them from their superview
  func removeArrangedSubviews() {
    arrangedSubviews.forEach {
      removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
}
