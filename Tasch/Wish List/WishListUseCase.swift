import Foundation
import FoundationExtensions

public protocol WishListUseCase: AnyObject {
  var observer: WishListUseCaseObserver? { get set }

  func updateWishList()
}

public protocol WishListUseCaseObserver: AnyObject {
  func updateState(_ state: WishListUseCaseState)
}

public enum WishListUseCaseState: Equatable {
  case loading
  case wishList([WishListItem])
  case error(Tasch.Error)
}

public class WishListUseCaseImp: WishListUseCase {
  public weak var observer: WishListUseCaseObserver? {
    didSet { updateObserver() }
  }

  private var notificationToken: Any?
  private let dataLayer: DataLayer
  private var state: WishListUseCaseState = .loading {
    didSet { updateObserver() }
  }

  public init(dataLayer: DataLayer) {
    self.dataLayer = dataLayer
    notificationToken = NotificationCenter.default
      .addObserver(forName: .wishListDidChange,
                   object: nil,
                   queue: nil,
                   using: { [weak self] _ in self?.updateWishList() })

    updateWishList()
  }

  public func updateWishList() {
    state = .loading
    dataLayer.userWishList { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(wishList):
        self.state = .wishList(wishList)
      case let .failure(error):
        self.state = .error(error)
      }
    }
  }

  private func updateObserver() {
    observer?.updateState(state)
  }
}
