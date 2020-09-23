import Foundation

class Localization {

  private let locale: Locale
  private lazy var currencyFormatter: NumberFormatter = {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.locale = locale
    currencyFormatter.numberStyle = .currency
    currencyFormatter.maximumFractionDigits = 0
    return currencyFormatter
  }()

  init(locale: Locale = .autoupdatingCurrent) {
    self.locale = locale
  }

  func `for`(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
  }

  func format(currency dollars: Int) -> String {
    return currencyFormatter.string(from: NSNumber(integerLiteral: dollars)) ?? ""
  }
}
