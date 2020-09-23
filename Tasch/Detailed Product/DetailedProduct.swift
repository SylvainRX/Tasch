import Foundation

public struct DetailedProduct: Equatable {

  public struct Dimension: Equatable {

    public enum Axis: Int {
      case height
      case width
      case depth
    }

    public let centimeters: Int
    public let inches: Int

    public init(centimeters: Int,
                inches: Int) {
      self.centimeters = centimeters
      self.inches = inches
    }
  }

  public let id: Int
  public let name: String?
  public let imageName: String?
  public let cost: Int?
  public let description: String?
  public let availableColors: [String]
  public let dimensions: [Dimension.Axis: Dimension]
  public let isInWishList: Bool?

  public init(id: Int,
              name: String?,
              imageName: String?,
              cost: Int?,
              description: String?,
              colors: [String],
              dimensions: [Dimension.Axis: Dimension],
              isInWishList: Bool) {
    self.id = id
    self.name = name
    self.imageName = imageName
    self.cost = cost
    self.description = description
    availableColors = colors
    self.dimensions = dimensions
    self.isInWishList = isInWishList
  }
}
