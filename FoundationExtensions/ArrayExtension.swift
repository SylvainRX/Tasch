import Foundation

extension Array {

  /// Remove the first element matching the rule
  public mutating func removeFirst(where isRuleMatchedBy: (Element) -> Bool) {
    var it = 0
    while it < count {
      if isRuleMatchedBy(self[it]) {
        remove(at: it)
        return
      }
      it += 1
    }
  }
}
