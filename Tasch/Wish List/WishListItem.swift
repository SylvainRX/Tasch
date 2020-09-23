import Foundation

public struct WishListItem: Equatable {
  public let id: Int
  public let name: String?
  public let imageName: String?
  public let cost: Int?
  public let description: String?
  public let inStockQuantity: Int?
  public let availableColors: [String]

  public init(id: Int,
              name: String?,
              imageName: String?,
              cost: Int?,
              description: String?,
              inStockQuantity: Int?,
              colors: [String]) {
    self.id = id
    self.name = name
    self.imageName = imageName
    self.cost = cost
    self.description = description
    self.inStockQuantity = inStockQuantity
    self.availableColors = colors
  }
}
