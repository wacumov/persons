public struct Person: Decodable, Sendable {
    public let id: ID
    public let name: String

    public typealias ID = Int
}
