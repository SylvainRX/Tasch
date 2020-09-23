import Foundation

public protocol DataLayer {

  /// Retrieve the product catalogue
  func productCatalogue(completion: @escaping (Result<[ProductCatalogueItem], Tasch.Error>) -> Void)

  /// Retrieve the detail of a product for the given id
  func detailedProduct(withId id: Int, completion: @escaping (Result<DetailedProduct, Tasch.Error>) -> Void)

  /// Retrieve the user's wish list
  func userWishList(completion: @escaping (Result<[WishListItem], Tasch.Error>) -> Void)

  /// Add the item of the given id to the wish list
  func addToWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Tasch.Error>) -> Void)

  /// Remove the items of the given id from the wish list
  func removeFromWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Tasch.Error>) -> Void)

  /// Retrieve the user's cart
  func userCart(completion: @escaping (Result<Cart, Tasch.Error>) -> Void)

  /// Check out the content of the user's cart
  func checkOut(completion: @escaping (Result<Void, Tasch.Error>) -> Void)
}
