import Foundation
import FoundationExtensions
import Tasch

class TaschDataLayer {

  private let fakeBags: [FakeBag]
  private let fakeResponseTime = 500

  // Set those variables to true to test the error handling for their respective data layer calls
  private var isProductCatalogueFakeFailing = false
  private var isDetailedProductFakeFailing = false
  private var isUserWishListFakeFailing = false
  private var isAddToWishListFakeFailing = false
  private var isRemoveFromWishListFakeFailing = false
  private var isUserCartFakeFailing = false
  private var isCheckOutFakeFailing = false

  private var userWishList = [WishListItem]() {
    didSet { NotificationCenter.default.post(name: .wishListDidChange, object: self) }
  }

  init?() {
    guard let path = Bundle.main.path(forResource: "Bags", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
      let bagsFakeData = try? JSONDecoder().decode(BagsFakeData.self, from: data) else { return nil }
    fakeBags = bagsFakeData.bags

    userWishList.append(Tasch.WishListItem(fakeBag: fakeBags[0]))
    userWishList.append(Tasch.WishListItem(fakeBag: fakeBags[1]))
    userWishList.append(Tasch.WishListItem(fakeBag: fakeBags[2]))
  }
}

extension TaschDataLayer: Tasch.DataLayer {
  
  func productCatalogue(completion: @escaping (Result<[Tasch.ProductCatalogueItem], Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isProductCatalogueFakeFailing {
        completion(.failure(.dataDecoding))
        self.isProductCatalogueFakeFailing = false
        return
      }

      let productCatalogue = self.fakeBags.map { ProductCatalogueItem(fakeBag: $0) }
      completion(.success(productCatalogue))
    }
  }

  func detailedProduct(withId id: Int, completion: @escaping (Result<Tasch.DetailedProduct, Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isDetailedProductFakeFailing {
        completion(.failure(.dataDecoding))
        self.isDetailedProductFakeFailing = false
        return
      }

      guard let fakeBag = self.fakeBags.first(where: { $0.id == id }) else {
        completion(.failure(.dataNotFound))
        return
      }
      let isInWishList = self.userWishList.contains { $0.id == id }
      let detailedProduct = Tasch.DetailedProduct(fakeBag: fakeBag, isInWishList: isInWishList)
      completion(.success(detailedProduct))
    }
  }

  func userWishList(completion: @escaping (Result<[Tasch.WishListItem], Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isUserWishListFakeFailing {
        completion(.failure(.dataDecoding))
        self.isUserWishListFakeFailing = false
        return
      }

      completion(.success(self.userWishList))
    }
  }

  func addToWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isAddToWishListFakeFailing {
        completion(.failure(.dataDecoding))
        self.isAddToWishListFakeFailing = false
        return
      }

      guard let fakeBag = self.fakeBags.first(where: { $0.id == itemId }) else {
        completion(.failure(.dataNotFound))
        return
      }
      let wishListItem = WishListItem(fakeBag: fakeBag)
      self.userWishList.append(wishListItem)
      completion(.success(()))
    }
  }

  func removeFromWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isRemoveFromWishListFakeFailing {
        completion(.failure(.dataDecoding))
        self.isRemoveFromWishListFakeFailing = false
        return
      }

      self.userWishList.removeFirst(where: { $0.id == itemId })
      completion(.success(()))
    }
  }

  func userCart(completion: @escaping (Result<Tasch.Cart, Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isUserCartFakeFailing {
        completion(.failure(.dataDecoding))
        self.isUserCartFakeFailing = false
        return
      }

      let totalCost = self.userWishList.reduce(0) { totalCost, wishListItem in totalCost + (wishListItem.cost ?? 0) }
      let cart = Tasch.Cart(totalCost: totalCost)
      completion(.success(cart))
    }
  }

  func checkOut(completion: @escaping (Result<Void, Tasch.Error>) -> Void) {
    // Dispatch on main queue as if the data was retrieved asynchronously from a server
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(fakeResponseTime)) {

      // Error handling test
      if self.isCheckOutFakeFailing {
        completion(.failure(.dataDecoding))
        self.isCheckOutFakeFailing = false
        return
      }

      self.userWishList = []
      completion(.success(()))
    }
  }
}

// MARK: - ProductCatalogueItem Factory
extension Tasch.ProductCatalogueItem {

  fileprivate init(fakeBag: FakeBag) {
    self.init(id: fakeBag.id, name: fakeBag.name, imageName: fakeBag.image)
  }
}

// MARK: - DetailedProduct Factory
extension Tasch.DetailedProduct {

  fileprivate init(fakeBag: FakeBag, isInWishList: Bool) {
    typealias DimensionDictionary = [Tasch.DetailedProduct.Dimension.Axis: Tasch.DetailedProduct.Dimension]

    let dimensionsElements: [DimensionDictionary.Element] = fakeBag.dimensions.compactMap { fakeDimension in
      let axis: Tasch.DetailedProduct.Dimension.Axis
      switch fakeDimension.dimension {
      case "height": axis = .height
      case "width": axis = .width
      case "depth": axis = .depth
      default: return nil
      }
      return (key: axis, value: Tasch.DetailedProduct.Dimension(centimeters: fakeDimension.centimeters, inches: fakeDimension.inches))
    }
    let dimensions: DimensionDictionary = .init(uniqueKeysWithValues: dimensionsElements)

    self.init(id: fakeBag.id,
              name: fakeBag.name,
              imageName: fakeBag.image,
              cost: fakeBag.price,
              description: fakeBag.description,
              colors: fakeBag.colors.map { $0.value },
              dimensions: dimensions,
              isInWishList: isInWishList)
  }
}

// MARK: - WishListItem Factory
extension Tasch.WishListItem {

  fileprivate init(fakeBag: FakeBag) {
    self.init(id: fakeBag.id,
              name: fakeBag.name,
              imageName: fakeBag.image,
              cost: fakeBag.price,
              description: fakeBag.shortDescription,
              inStockQuantity: fakeBag.quantity,
              colors: fakeBag.colors.map { $0.value })
  }
}
