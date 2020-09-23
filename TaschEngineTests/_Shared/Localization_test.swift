@testable import TaschEngine
import XCTest

class Localization_test: XCTestCase {

  func test_givenCurrency_whenFormat_thenString() {
    [
      (localeId: "fr_CA", dollars: 0, expectation: "0 $"),
      (localeId: "en_CA", dollars: 0, expectation: "$0"),
      (localeId: "en_US", dollars: 0, expectation: "$0"),
      (localeId: "es_US", dollars: 0, expectation: "$0"),
      (localeId: "fr_CA", dollars: 123_123, expectation: "123 123 $"),
      (localeId: "en_CA", dollars: 123_123, expectation: "$123,123"),
      (localeId: "en_US", dollars: 123_123, expectation: "$123,123"),
      (localeId: "es_US", dollars: 123_123, expectation: "$123,123"),
      (localeId: "fr_CA", dollars: 3_123_123, expectation: "3 123 123 $"),
      (localeId: "en_CA", dollars: 3_123_123, expectation: "$3,123,123"),
      (localeId: "en_US", dollars: 3_123_123, expectation: "$3,123,123"),
      (localeId: "es_US", dollars: 3_123_123, expectation: "$3,123,123"),
    ]
    .forEach { localeId, dollars, expectation in
      let sut = Localization(locale: Locale(identifier: localeId))
      XCTAssertEqual(sut.format(currency: dollars), expectation, "LocaleId: \(localeId)")
    }
  }
}
