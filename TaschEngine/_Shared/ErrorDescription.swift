import Foundation
import Resolver
import Tasch

struct ErrorDescription: Equatable {
  let title: String
  let message: String

  init(title: String, message: String) {
    self.title = title
    self.message = message
  }
}

extension ErrorDescription {

  init(taschError: Tasch.Error) {
    let localization: Localization = Resolver.resolve()
      switch taschError {
    case .dataDecoding:
      self.init(title: localization.for("error.title"),
                message: localization.for("error.data_decoding.message"))
    case .dataNotFound:
      self.init(title: localization.for("error.title"),
                message: localization.for("error.data_not_found.message"))
    case .networkNoInternet:
      self.init(title: localization.for("error.title"),
                message: localization.for("error.network_no_interner.message"))
    }
  }
}
