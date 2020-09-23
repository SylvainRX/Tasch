import Tasch

class DataLayerSpy: DataLayer {

  var productCatalogueArgs = [(Result<[ProductCatalogueItem], Tasch.Error>) -> Void]()
  func productCatalogue(completion: @escaping (Result<[ProductCatalogueItem], Tasch.Error>) -> Void) {
    productCatalogueArgs.append(completion)
  }

  var detailedProductArgs = [(id: Int, completion: (Result<DetailedProduct, Error>) -> Void)]()
  func detailedProduct(withId id: Int, completion: @escaping (Result<DetailedProduct, Error>) -> Void) {
    detailedProductArgs.append((id, completion))
  }

  var userWishListArgs = [(Result<[WishListItem], Tasch.Error>) -> Void]()
  func userWishList(completion: @escaping (Result<[WishListItem], Error>) -> Void) {
    userWishListArgs.append(completion)
  }

  var addToWishListArgs = [(itemId: Int, completion: (Result<Void, Error>) -> Void)]()
  func addToWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    addToWishListArgs.append((itemId, completion))
  }

  var removeFromWishListArgs = [(itemId: Int, completion: (Result<Void, Error>) -> Void)]()
  func removeFromWishList(itemWithId itemId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    removeFromWishListArgs.append((itemId, completion))
  }

  var userCartArgs = [(Result<Cart, Error>) -> Void]()
  func userCart(completion: @escaping (Result<Cart, Error>) -> Void) {
    userCartArgs.append(completion)
  }

  var checkOutArgs = [(Result<Void, Error>) -> Void]()
  func checkOut(completion: @escaping (Result<Void, Error>) -> Void) {
    checkOutArgs.append(completion)
  }
}
