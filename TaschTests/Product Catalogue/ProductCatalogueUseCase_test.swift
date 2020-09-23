import Tasch
import XCTest

class ProductCatalogueUseCaseObserverSpy: ProductCatalogueUseCaseObserver {

  var updateStateArgs = [ProductCatalogueUseCaseState]()
  func updateState(_ state: ProductCatalogueUseCaseState) {
    updateStateArgs.append(state)
  }
}

class ProductCatalogueUseCase_test: XCTestCase {

  func makeSUT(assignObserver: Bool = true) -> (sut: ProductCatalogueUseCase,
                                                observerSpy: ProductCatalogueUseCaseObserverSpy,
                                                dataLayerSpy: DataLayerSpy) {
    let dataLayerSpy = DataLayerSpy()
    let sut = ProductCatalogueUseCaseImp(dataLayer: dataLayerSpy)
    let observerSpy = ProductCatalogueUseCaseObserverSpy()
    if assignObserver { sut.observer = observerSpy }
    return (sut, observerSpy, dataLayerSpy)
  }
}

// MARK: - Retain Cycles
extension ProductCatalogueUseCase_test {

  func test_givenObserver_whenSetSutObserverAndReleaseLocalStrongReference_thenSutObserverIsNil() {
    let sut = makeSUT().sut
    var observer: ProductCatalogueUseCaseObserver? = ProductCatalogueUseCaseObserverSpy()
    sut.observer = observer
    XCTAssertNotNil(sut.observer)
    observer = nil
    XCTAssertNil(sut.observer, "Reference to observer is weak to prevent retain cycles. Lower level modules retain the SUT")
  }
}

// MARK: - Initial State
extension ProductCatalogueUseCase_test {

  func test_givenInitialState_whenAssignObserver_thenUpdateObserverStateWithState() {
    let (sut, observerSpy, _) = makeSUT(assignObserver: false)
    XCTAssertEqual(observerSpy.updateStateArgs.count, 0)
    sut.observer = observerSpy
    XCTAssertEqual(observerSpy.updateStateArgs.count, 1)
    XCTAssertEqual(observerSpy.updateStateArgs.last, .loading)
  }

  func test_whenInit_thenCallDataLayerProductCatalogue() {
    let dataLayer = makeSUT().dataLayerSpy
    XCTAssertEqual(dataLayer.productCatalogueArgs.count, 1, "Request product catalogue on initialization")
  }
}

// MARK: - State Updates
extension ProductCatalogueUseCase_test {

  func assertGiven(productCatalogueResult: Result<[ProductCatalogueItem], Tasch.Error>,
                   thenUpdateToState state: ProductCatalogueUseCaseState,
                   _ message: String = "",
                   line: UInt = #line) {
    let (sut, observerSpy, dataLayerSpy) = makeSUT()

    if [true, false].randomElement()! {
      sut.updateCatalogue()
      XCTAssertEqual(dataLayerSpy.productCatalogueArgs.count, 2, "Update catalogue calls productCatalogue on data layer and have the same behavior as the one made on SUT initialization")
    }

    dataLayerSpy.productCatalogueArgs.last?(productCatalogueResult)
    XCTAssertEqual(observerSpy.updateStateArgs.last, state, message, line: line)
  }

  func test_givenDataLayerProductCatalogueCall_whenCompleteWithSuccess_thenErrorState() {
    let catalogue = ProductCatalogueItem.makeProductCatalogue(withItemCount: 10)
    assertGiven(productCatalogueResult: .success(catalogue),
                thenUpdateToState: .productCatalogue(catalogue))
  }

  func test_givenDataLaterProductCatalogueCall_whenCompleteWithEmptyCatalogueSuccess_thenErrorDataNotFound() {
    let catalogue = ProductCatalogueItem.makeProductCatalogue(withItemCount: 0)
    assertGiven(productCatalogueResult: .success(catalogue),
                thenUpdateToState: .error(.dataNotFound),
                "When the product catalogue is empty update state to data not found error")
  }

  func test_givenDataLayerProductCatalogueCall_whenCompleteWithError_thenErrorState() { 
    let error = Tasch.Error.allCases.randomElement()!
    assertGiven(productCatalogueResult: .failure(error),
                thenUpdateToState: .error(error))
  }

  func test_whenUpdateCatalogue_thenUpdateStateToLoading() {
    let (sut, observerSpy, _) = makeSUT()
    let initialStateUpdateCount = observerSpy.updateStateArgs.count
    sut.updateCatalogue()
    XCTAssertEqual(observerSpy.updateStateArgs.count, initialStateUpdateCount + 1)
    XCTAssertEqual(observerSpy.updateStateArgs.last, .loading)
  }
}

// MARK: Entity Factory
extension ProductCatalogueItem {

  static func makeProductCatalogue(withItemCount itemCount: Int) -> [ProductCatalogueItem] {
    (0 ..< itemCount).map {
      ProductCatalogueItem(id: $0, name: String($0), imageName: String($0))
    }
  }
}
