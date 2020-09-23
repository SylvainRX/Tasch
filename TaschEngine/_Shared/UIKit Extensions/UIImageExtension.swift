import UIKit

extension UIImage {

  /// Initialize with a local image file URL
  /// Fails if the given file does not exist, is invalid, or is nil.
  /// - parameter localImageFileName: The name of an image file in the bundle
  convenience init?(localImageFileName: String?) {
    guard let localImageFileName = localImageFileName else { return nil }
    self.init(named: localImageFileName,
              in: Bundle.main,
              compatibleWith: nil)
  }
}
