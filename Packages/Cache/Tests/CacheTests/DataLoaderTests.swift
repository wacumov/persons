import Cache
import Foundation
import Testing

final class DataLoaderTests {
    @Test func ignoreCachePolicyFetchesFreshValue() async throws {
        let cache = MockCache()
        try cache.setValue("cached", forKey: "test")
        var loadCount = 0

        let loader = DataLoader(cache: cache) { _ in
            loadCount += 1
            return "fresh"
        }

        let value: String = try await loader.get(key: "test", policy: .ignoreCache)
        #expect(value == "fresh")
        #expect(loadCount == 1)
        #expect(try cache.getValue(forKey: "test") == "fresh")
    }

    @Test func ignoreCachePolicyFallsBackToCacheOnFailure() async throws {
        let cache = MockCache()
        try cache.setValue("cached", forKey: "test")

        let loader = DataLoader<String, MockCache>(cache: cache) { _ in
            throw CocoaError(.fileNoSuchFile)
        }

        let value: String = try await loader.get(key: "test", policy: .ignoreCache)
        #expect(value == "cached")
    }

    @Test func ignoreCachePolicyPropagatesErrorWhenNoCache() async throws {
        let loader = DataLoader<String, MockCache>(cache: MockCache()) { _ in
            throw CocoaError(.fileNoSuchFile)
        }

        await #expect(throws: CocoaError.self) {
            let _: String = try await loader.get(key: "test", policy: .ignoreCache)
        }
    }

    @Test func mixedPoliciesHandleConcurrency() async throws {
        let cache = MockCache()
        var loadCount = 0

        let loader = DataLoader(cache: cache) { key in
            loadCount += 1
            try await Task.sleep(nanoseconds: 100_000)
            return "fresh-\(key)"
        }

        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                let value: String = try await loader.get(key: "test", policy: .ignoreCache)
                #expect(value == "fresh-test")
            }
            group.addTask {
                let value: String = try await loader.get(key: "test")
                #expect(value == "fresh-test")
            }
        }

        #expect(loadCount == 1)
        #expect(try cache.getValue(forKey: "test") == "fresh-test")
    }

    @Test func useCachePolicyWithExpiredValue() async throws {
        let cache = MockCache()
        var loadCount = 0

        let loader = DataLoader(cache: cache) { _ in
            loadCount += 1
            return "fresh"
        }

        try cache.setValue("stale", forKey: "test")

        let value1: String = try await loader.get(key: "test")
        #expect(value1 == "stale")

        let value2: String = try await loader.get(key: "test", policy: .ignoreCache)
        #expect(value2 == "fresh")

        let value3: String = try await loader.get(key: "test")
        #expect(value3 == "fresh")
        #expect(loadCount == 1)
    }
}

private final class MockCache: Caching, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    private let queue = DispatchQueue(label: "MockCacheQueue", attributes: .concurrent)

    func getValue<Value: Codable>(forKey key: String) throws -> Value? {
        try queue.sync {
            guard let data = storage[key] else {
                return nil
            }
            return try JSONDecoder().decode(Value.self, from: data)
        }
    }

    func setValue(_ value: some Codable, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        queue.sync(flags: .barrier) {
            storage[key] = data
        }
    }
}
