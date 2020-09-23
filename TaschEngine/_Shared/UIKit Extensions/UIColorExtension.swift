import UIKit

extension UIColor {

  /// Initialize UIColor from hexadecimal Int
  convenience init?(hex: Int) {
    self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
  }

  /// Initialize UIColor from hexadecimal String
  convenience init?(hexString: String) {
    guard let hex = Int(hexString, radix: 16) else { return nil }
    self.init(hex: hex)
  }

  private convenience init?(red: Int, green: Int, blue: Int) {
    guard red >= 0, red <= 255,
      green >= 0, green <= 255,
      blue >= 0, blue <= 255
    else { return nil }
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  /// 1 px resizable image colored with self
  public var image: UIImage {
    let canvas = CGRect(x: 0, y: 0, width: 1, height: 1)

    UIGraphicsBeginImageContext(canvas.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(cgColor)
    context?.fill(canvas)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    let result = image?.resizableImage(withCapInsets: .zero)
    UIGraphicsEndImageContext()

    return result!
  }
}
