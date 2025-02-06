public struct Person: Decodable {
    public let id: ID
    public let name: String

    public typealias ID = Int
}
