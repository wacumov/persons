public struct Person: Codable, Sendable {
    public let id: ID
    public let name: String
    public let email: [Contact]?
    public let phone: [Contact]?

    public typealias ID = Int

    public struct Contact: Codable, Sendable {
        public let value: String
        public let primary: Bool?
        public let label: String?
    }
}
