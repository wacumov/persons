public actor DataLoader<Value: Codable & Sendable, Cache: Caching> {
    private let cache: Cache
    private let load: (String) async throws -> Value
    private var ongoingTasks: [String: Task<Value, Error>] = [:]

    public init(cache: Cache, load: @escaping (String) async throws -> Value) {
        self.cache = cache
        self.load = load
    }

    public func get(key: String, policy: CachePolicy = .useCache) async throws -> Value {
        if policy == .useCache, let cached: Value = try cache.getValue(forKey: key) {
            return cached
        }
        if let existing = ongoingTasks[key] {
            return try await existing.value
        }
        let task = Task<Value, Error> {
            defer {
                ongoingTasks[key] = nil
            }
            do {
                let value = try await load(key)
                try cache.setValue(value, forKey: key)
                return value
            } catch {
                if policy == .ignoreCache, let cached: Value = try cache.getValue(forKey: key) {
                    return cached
                }
                throw error
            }
        }
        ongoingTasks[key] = task
        return try await task.value
    }
}
