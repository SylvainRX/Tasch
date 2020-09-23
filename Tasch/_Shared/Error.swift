import Foundation

public enum Error: Swift.Error, Equatable, CaseIterable {
  case dataDecoding
  case dataNotFound
  case networkNoInternet
}
