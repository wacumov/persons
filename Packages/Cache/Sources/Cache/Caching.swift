public protocol Caching {
    func getValue<Value: Codable>(forKey key: String) throws -> Value?
    func setValue<Value: Codable>(_ value: Value, forKey key: String) throws
}
