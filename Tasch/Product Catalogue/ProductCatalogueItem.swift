import Foundation

public struct ProductCatalogueItem: Equatable {
  public let id: Int
  public let name: String?
  public let imageName: String?

  public init(id: Int,
              name: String?,
              imageName: String?) {
    self.id = id
    self.name = name
    self.imageName = imageName
  }
}
