public struct Person: Decodable, Sendable {
    public let id: ID
    public let name: String
    public let email: [Contact]?
    public let phone: [Contact]?

    public typealias ID = Int

    public struct Contact: Decodable, Sendable {
        public let value: String
        public let primary: Bool?
        public let label: String?
    }
}
