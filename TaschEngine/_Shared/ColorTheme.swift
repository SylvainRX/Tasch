import UIKit

protocol ColorTheme {
  var cardBackground: UIColor { get }
  var destructiveActionBackground: UIColor { get }
  var destructiveActionText: UIColor { get }
  var enticingActionBackground: UIColor { get }
  var enticingActionText: UIColor { get }
  var firstLevelBackground: UIColor { get }
  var navigationBackground: UIColor { get }
  var navigationText: UIColor { get }
  var productBackground: UIColor { get }
  var promotionText: UIColor { get }
  var ratingScaleEmpty: UIColor { get }
  var ratingScaleFull: UIColor { get }
  var secondLevelBackground: UIColor { get }
  var shadow: UIColor { get }
  var textAction: UIColor { get }
  var textDefault: UIColor { get }
  var textDiscrete: UIColor { get }
  var textWarning: UIColor { get }
}

class LightColorTheme: ColorTheme {
  private(set) var cardBackground = UIColor(hex: 0xFDFEFF)!
  private(set) var destructiveActionBackground = UIColor(hex: 0x010101)!
  private(set) var destructiveActionText = UIColor(hex: 0xFDFEFF)!
  private(set) var enticingActionBackground = UIColor(hex: 0xEC3331)!
  private(set) var enticingActionText = UIColor(hex: 0xFDFEFF)!
  private(set) var firstLevelBackground = UIColor(hex: 0xD9D9D9)!
  private(set) var navigationBackground = UIColor(hex: 0x4A9577)!
  private(set) var navigationText = UIColor(hex: 0xFEFCFC)!
  private(set) var productBackground = UIColor(hex: 0xFFFFFF)!
  private(set) var promotionText = UIColor(hex: 0x4A9577)!
  private(set) var ratingScaleEmpty = UIColor(hex: 0xD8D9DB)!
  private(set) var ratingScaleFull = UIColor(hex: 0xD9B23A)!
  private(set) var secondLevelBackground = UIColor(hex: 0xF1F0F5)!
  private(set) var shadow = UIColor(hex: 0x000000)!
  private(set) var textAction = UIColor(hex: 0x1C92F5)!
  private(set) var textDefault = UIColor(hex: 0x010101)!
  private(set) var textDiscrete = UIColor(hex: 0x68696B)!
  private(set) var textWarning = UIColor(hex: 0xD63A3E)!
}
