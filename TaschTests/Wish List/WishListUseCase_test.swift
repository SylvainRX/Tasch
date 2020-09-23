import Tasch
import XCTest

class WishListUseCaseObserverSpy: WishListUseCaseObserver {

  var updateStateArgs = [WishListUseCaseState]()
  func updateState(_ state: WishListUseCaseState) {
    updateStateArgs.append(state)
  }
}

class WishListUseCase_test: XCTestCase {

  func makeSUT(assignObserver: Bool = true) -> (sut: WishListUseCase,
                                                observerSpy: WishListUseCaseObserverSpy,
                                                dataLayerSpy: DataLayerSpy) {
    let dataLayerSpy = DataLayerSpy()
    let sut = WishListUseCaseImp(dataLayer: dataLayerSpy)
    let observerSpy = WishListUseCaseObserverSpy()
    if assignObserver { sut.observer = observerSpy }
    return (sut, observerSpy, dataLayerSpy)
  }
}

// MARK: - Retain Cycles
extension WishListUseCase_test {

  func test_givenObserver_whenSetSutObserverAndReleaseLocalStrongReference_thenSutObserverIsNil() {
    let sut = makeSUT().sut
    var observer: WishListUseCaseObserver? = WishListUseCaseObserverSpy()
    sut.observer = observer
    XCTAssertNotNil(sut.observer)
    observer = nil
    XCTAssertNil(sut.observer, "Reference to observer is weak to prevent retain cycles. Lower level modules retain the SUT")
  }
}

// MARK: - Initial State
extension WishListUseCase_test {

  func test_givenInitialState_whenAssignObserver_thenUpdateObserverStateWithState() {
    let (sut, observerSpy, _) = makeSUT(assignObserver: false)
    XCTAssertEqual(observerSpy.updateStateArgs.count, 0)
    sut.observer = observerSpy
    XCTAssertEqual(observerSpy.updateStateArgs.count, 1)
    XCTAssertEqual(observerSpy.updateStateArgs.last, .loading)
  }

  func test_whenInit_thenCallDataLayerWishList() {
    let dataLayer = makeSUT().dataLayerSpy
    XCTAssertEqual(dataLayer.userWishListArgs.count, 1, "Request product wish list on initialization")
  }
}

// MARK: - State Updates
extension WishListUseCase_test {

  func assertGiven(userWishListResult: Result<[WishListItem], Tasch.Error>,
                   thenUpdateToState state: WishListUseCaseState,
                   _ message: String = "",
                   line: UInt = #line) {
    let (sut, observerSpy, dataLayerSpy) = makeSUT()

    if [true, false].randomElement()! {
      sut.updateWishList()
      XCTAssertEqual(dataLayerSpy.userWishListArgs.count, 2, "Update wish list calls wish list on data layer and have the same behavior as the one made on SUT initialization")
    }

    dataLayerSpy.userWishListArgs.last?(userWishListResult)
    XCTAssertEqual(observerSpy.updateStateArgs.last, state, message, line: line)
  }

  func test_givenDataLayerWishListCall_whenCompleteWithSuccess_thenErrorState() {
    let wishList = WishListItem.makeWishList(withItemCount: 10)
    assertGiven(userWishListResult: .success(wishList),
                thenUpdateToState: .wishList(wishList))
  }

  func test_givenDataLaterWishListCall_whenCompleteWithEmptyWishListSuccess_thenEmptyWishList() {
    let wishList = WishListItem.makeWishList(withItemCount: 0)
    assertGiven(userWishListResult: .success(wishList),
                thenUpdateToState: .wishList(wishList),
                "When the product wish list is empty update state to data not found error")
  }

  func test_givenDataLayerWishListCall_whenCompleteWithError_thenErrorState() {
    let error = Tasch.Error.allCases.randomElement()!
    assertGiven(userWishListResult: .failure(error),
                thenUpdateToState: .error(error))
  }

  func test_whenUpdateWishList_thenUpdateStateToLoading() {
    let (sut, observerSpy, _) = makeSUT()
    let initialStateUpdateCount = observerSpy.updateStateArgs.count
    sut.updateWishList()
    XCTAssertEqual(observerSpy.updateStateArgs.count, initialStateUpdateCount + 1)
    XCTAssertEqual(observerSpy.updateStateArgs.last, .loading)
  }
}

// MARK: - Wish List Updates
extension WishListUseCase_test {

  func test_givenWishListDidChangeNotifName_whenPostNotification_thenSUTUpdateWishList() {
    let (sut, _, dataLayerSpy) = makeSUT(); _ = sut
    let dataLayerUserWishListCallCount = dataLayerSpy.userWishListArgs.count
    NotificationCenter.default.post(name: .wishListDidChange, object: self)
    XCTAssertEqual(dataLayerSpy.userWishListArgs.count, dataLayerUserWishListCallCount + 1)
  }
}

// MARK: - Entity Factory
extension WishListItem {

  static func makeWishList(withItemCount itemCount: Int) -> [WishListItem] {
    (0 ..< itemCount).map {
      WishListItem(id: $0, name: String($0), imageName: String($0), cost: $0, description: String($0), inStockQuantity: $0, colors: [])
    }
  }
}
