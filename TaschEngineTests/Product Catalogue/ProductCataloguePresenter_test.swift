@testable import Tasch
@testable import TaschEngine
import XCTest

class ProductCatalogueViewSpy: ProductCatalogueView {

  var updateStateArgs = [ProductCatalogue.ViewState]()
  func updateState(_ state: ProductCatalogue.ViewState) {
    updateStateArgs.append(state)
  }
}

class ProductCatalogueRouterSpy: ProductCatalogueRouter {

  var routeToProductDetailArgs = [(productId: Int, name: String)]()
  func routeToProductDetail(productId: Int, name: String) {
    routeToProductDetailArgs.append((productId, name))
  }
}

class ProductCatalogueUseCaseSpy: Tasch.ProductCatalogueUseCase {
  var observer: ProductCatalogueUseCaseObserver?

  var updateCatalogueCount = 0
  func updateCatalogue() {
    updateCatalogueCount += 1
  }
}

class ProductCataloguePresenter_test: XCTestCase {
  var sutReference: Any?

  override func tearDown() {
    sutReference = nil
  }

  func makeSUT(assignView: Bool = true) -> (sut: ProductCataloguePresenter,
                                            viewSpy: ProductCatalogueViewSpy,
                                            routerSpy: ProductCatalogueRouterSpy,
                                            useCaseSpy: ProductCatalogueUseCaseSpy) {
    let useCaseSpy = ProductCatalogueUseCaseSpy()
    let viewSpy = ProductCatalogueViewSpy()
    let routerSpy = ProductCatalogueRouterSpy()
    let sut = ProductCataloguePresenter(router: routerSpy, useCase: useCaseSpy)
    if assignView { sut.view = viewSpy }
    return (sut, viewSpy, routerSpy, useCaseSpy)
  }
}

// MARK: - References
extension ProductCataloguePresenter_test {

  func test_givenView_whenSetSutViewAndReleaseLocalStrongReference_thenSutViewIsNil() {
    let sut = makeSUT().sut
    var view: ProductCatalogueViewSpy? = ProductCatalogueViewSpy()
    sut.view = view
    XCTAssertNotNil(sut.view)
    view = nil
    XCTAssertNil(sut.view, "Reference to view is weak to prevent retain cycles. The view is of a lower level, thus must retains the presenter")
  }

  func test_givenUseCase_whenInitSutAndReleaseLocalUseCaseStrongReference_thenSutRetainsUseCase() {
    var useCase: ProductCatalogueUseCaseSpy? = ProductCatalogueUseCaseSpy()
    weak var weakUseCase = useCase
    sutReference = ProductCataloguePresenter(router: ProductCatalogueRouterSpy(),
                                             useCase: useCase!)
    useCase = nil
    XCTAssertNotNil(weakUseCase, "Reference to use case is strong. The SUT is of a lower level than the use case, thus retains it")
  }

  func test_givenUseCase_whenInit_thenSetsSelfAsUseCaseObserver() {
    let (sut, _, _, useCaseSpy) = makeSUT()
    XCTAssertTrue(useCaseSpy.observer === sut, "SUT is the use case observer")
  }
}

// MARK: Initial State
extension ProductCataloguePresenter_test {

  func test_givenView_whenSetView_thenUpdateViewWithCurrrentViewState() {
    let (sut, viewSpy, _, _) = makeSUT(assignView: false)
    XCTAssertEqual(viewSpy.updateStateArgs.count, 0)
    sut.view = viewSpy
    XCTAssertEqual(viewSpy.updateStateArgs.count, 1)
    XCTAssertEqual(viewSpy.updateStateArgs.last, .loading)
  }
}

// MARK: - State Updates
extension ProductCataloguePresenter_test {

  func test_givenLoadingState_whenUpdateState_thenUpdateViewToLoadingState() {
    let (sut, viewSpy, _, _) = makeSUT()
    let initialViewUpdateCount = viewSpy.updateStateArgs.count
    sut.updateState(.loading)
    XCTAssertEqual(viewSpy.updateStateArgs.count, initialViewUpdateCount + 1)
    XCTAssertEqual(viewSpy.updateStateArgs.last, .loading)
  }

  func test_givenProductCatalogue_thenUpdateState_thenUpdateViewToProductCatalogueState() {

    func assertGiven(taschProductCatalogue: [Tasch.ProductCatalogueItem],
                     thenConvertToModel model: [ProductCatalogue.Model],
                     _ message: String = "",
                     line: UInt) {
      let (sut, viewSpy, _, _) = makeSUT()
      let initialViewUpdateCount = viewSpy.updateStateArgs.count
      sut.updateState(.productCatalogue(taschProductCatalogue))
      XCTAssertEqual(viewSpy.updateStateArgs.count, initialViewUpdateCount + 1, line: line)
      XCTAssertEqual(viewSpy.updateStateArgs.last, .productCatalogue(model), message, line: line)
    }

    [
      (taschProductCatalogue: [
        ProductCatalogueItem(id: 1, name: "name1", imageName: "name1"),
        ProductCatalogueItem(id: 2, name: "name2", imageName: "name2"),
      ], model: [
        ProductCatalogue.Model(id: 1, name: "name1", imageName: "name1"),
        ProductCatalogue.Model(id: 2, name: "name2", imageName: "name2"),
      ],
       message: "Tasch ProductCatalogueItem.s are converted to ProductCatalogue.Model.s", line: #line),

      (taschProductCatalogue: [
        ProductCatalogueItem(id: 1, name: "", imageName: "name1"),
        ProductCatalogueItem(id: 2, name: nil, imageName: "name2"),
      ],
       model: [],
       message: "Tasch ProductCatalogueItem.s with nil or empty name are discarded", line: #line),

      (taschProductCatalogue: [],
       model: [],
       message: "Empty product catalog, should not happen", line: #line),
    ]
    .forEach { taschProductCatalogue, model, message, line in
      assertGiven(taschProductCatalogue: taschProductCatalogue, thenConvertToModel: model, message, line: line)
    }
  }

  func test_givenErrorState_whenUpdateState_thenUpdateViewToErrorState() {
    let (sut, viewSpy, _, _) = makeSUT()
    let initialViewUpdateCount = viewSpy.updateStateArgs.count
    let taschError = Tasch.Error.allCases.randomElement()!
    sut.updateState(.error(taschError))
    XCTAssertEqual(viewSpy.updateStateArgs.count, initialViewUpdateCount + 1)
    XCTAssertEqual(viewSpy.updateStateArgs.last, .error(ErrorDescription(taschError: taschError)))
  }
}

// MARK: - Show Detail for Product
extension ProductCataloguePresenter_test {

  func test_givenNoProductCatalogueItems_whenShowDetailForProductWithId_thenDoNotRoute() {
    let (sut, _, routerSpy, _) = makeSUT()
    sut.showDetailForProduct(withId: 1)
    XCTAssertEqual(routerSpy.routeToProductDetailArgs.count, 0)
  }

  func test_givenProductCatalogueItems_whenShowDetailForProductWithUnknownId_thenDoNotRoute() {
    let (sut, _, routerSpy, _) = makeSUT()
    sut.updateState(.productCatalogue([ProductCatalogueItem(id: 2, name: "2", imageName: "2")]))
    sut.showDetailForProduct(withId: 1)
    XCTAssertEqual(routerSpy.routeToProductDetailArgs.count, 0)
  }

  func test_givenProductCatalogueItems_whenShowDetailForProductWithKnownId_thenRouteToProductDetailWithId() {
    let (sut, _, routerSpy, _) = makeSUT()
    sut.updateState(.productCatalogue([ProductCatalogueItem(id: 11111, name: "the first", imageName: "1")]))
    sut.showDetailForProduct(withId: 11111)
    XCTAssertEqual(routerSpy.routeToProductDetailArgs.count, 1)
    XCTAssertEqual(routerSpy.routeToProductDetailArgs.last?.productId, 11111)
    XCTAssertEqual(routerSpy.routeToProductDetailArgs.last?.name, "the first")
  }
}

// MARK: - Refresh Catalogue
extension ProductCataloguePresenter_test {

  func test_whenRefreshCatalogue_thenCallUseCaseUpdateCatalogue() {
    let (sut, _, _, useCaseSpy) = makeSUT()
    XCTAssertEqual(useCaseSpy.updateCatalogueCount, 0)
    sut.refreshCatalogue()
    XCTAssertEqual(useCaseSpy.updateCatalogueCount, 1)
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
