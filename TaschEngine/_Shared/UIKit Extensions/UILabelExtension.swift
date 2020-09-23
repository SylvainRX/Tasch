import Resolver
import UIKit

// MARK: - Style
extension UILabel {

  enum Style {
    case `default`
    case discreteTitle
    case discreteMessage
    case smallPriceTag
    case mediumPriceTag
    case bigPriceTag
    case warning
  }

  func applyLabelStyle(_ style: Style) {
    switch style {
    case .default:
      applyDefaultStyle()
    case .discreteTitle:
      applyDiscreteTitleStyle()
    case .discreteMessage:
      applyDiscreteMessageStyle()
    case .smallPriceTag:
      applySmallPriceTagStyle()
    case .mediumPriceTag:
      applyMediumPriceTagStyle()
    case .bigPriceTag:
      applyBigPriceTagStyle()
    case .warning:
      applyWarningStyle()
    }
  }

  private func applyDefaultStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDefault
    font = .systemFont(ofSize: 15, weight: .medium)
  }

  private func applyDiscreteTitleStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDiscrete
    font = .systemFont(ofSize: 13, weight: .bold)
  }

  private func applyDiscreteMessageStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDiscrete
    font = .systemFont(ofSize: 13, weight: .medium)
  }

  private func applySmallPriceTagStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDiscrete
    font = .systemFont(ofSize: 14, weight: .regular)
  }

  private func applyMediumPriceTagStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDiscrete
    font = .systemFont(ofSize: 22, weight: .light)
  }

  private func applyBigPriceTagStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textDefault
    font = .systemFont(ofSize: 40, weight: .light)
  }

  private func applyWarningStyle() {
    let colorTheme: ColorTheme = Resolver.resolve()
    textColor = colorTheme.textWarning
    font = .systemFont(ofSize: 13, weight: .semibold)
  }
}
