import Foundation

struct BagsFakeData: Decodable {
  let bags: [FakeBag]
}

struct FakeBag: Decodable {
  let id: Int
  let name: String
  let shortDescription: String
  let description: String
  let colors: [FakeColor]
  let dimensions: [FakeDimension]
  let price: Int
  let quantity: Int
  let image: String
}

struct FakeColor: Decodable {
  let value: String
}

struct FakeDimension: Decodable {
  let dimension: String
  let centimeters: Int
  let inches: Int
}
