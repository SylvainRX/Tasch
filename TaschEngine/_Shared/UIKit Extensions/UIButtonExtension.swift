import Resolver
import UIKit

// MARK: - Style
extension UIButton {

  enum Style {
    case `default`
    case enticing
    case destructive
  }

  func applyButtonStyle(_ style: Style) {
    switch style {
    case .default:
      applyDefaultStyle()
    case .enticing:
      applyEnticingStyle()
    case .destructive:
      applyDestructiveStyle()
    }
  }

  private func applyDefaultStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    setTitleColor(colorTheme.textAction, for: .normal)
    titleLabel?.font = .systemFont(ofSize: 16)
  }

  private func applyEnticingStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    setTitleColor(colorTheme.enticingActionText, for: .normal)
    setBackgroundImage(colorTheme.enticingActionBackground.image, for: .normal)
    titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    contentEdgeInsets = UIEdgeInsets(top: 11, left: 25, bottom: 11, right: 25)
    layer.cornerRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 2
    layer.masksToBounds = true
  }

  private func applyDestructiveStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    setTitleColor(colorTheme.destructiveActionText, for: .normal)
    setBackgroundImage(colorTheme.destructiveActionBackground.image, for: .normal)
    titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    contentEdgeInsets = UIEdgeInsets(top: 11, left: 25, bottom: 11, right: 25)
    layer.cornerRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowRadius = 2
    layer.masksToBounds = true
  }
}
