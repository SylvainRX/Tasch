import Foundation

public struct Cart: Equatable {
  public let totalCost: Int?

  public init(totalCost: Int?) {
    self.totalCost = totalCost
  }
}
