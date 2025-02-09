import Cache
import Foundation
import Testing

final class DiskCacheTests {
    private let sut = DiskCache()

    @Test func setAndGetValue() throws {
        try sut.setValue("value", forKey: "key")
        let value: String? = try sut.getValue(forKey: "key")
        #expect(value == "value")
    }

    @Test func getNonExistentValue() throws {
        let value: String? = try sut.getValue(forKey: "nonExistentKey")
        #expect(value == nil)
    }

    @Test func overwriteExistingValue() throws {
        try sut.setValue(1, forKey: "number")
        try sut.setValue(2, forKey: "number")
        let value: Int? = try sut.getValue(forKey: "number")
        #expect(value == 2)
    }

    @Test func concurrentAccess() async throws {
        let sut = DiskCache()
        let taskCount = 10
        try await withThrowingTaskGroup(of: Void.self) { group in
            for i in 0 ..< taskCount {
                group.addTask {
                    try await Task.detached {
                        try sut.setValue("value\(i)", forKey: "key\(i)")
                    }.value
                }
            }
            try await group.waitForAll()
        }
        for i in 0 ..< taskCount {
            let value: String? = try sut.getValue(forKey: "key\(i)")
            #expect(value == "value\(i)")
        }
    }

    @Test func concurrentAccessSameKey() async throws {
        let sut = DiskCache()
        let taskCount = 100, key = "samekey"
        try await withThrowingTaskGroup(of: Void.self) { group in
            for i in 0 ..< taskCount {
                group.addTask {
                    try await Task.detached {
                        try sut.setValue("value\(i)", forKey: key)
                        let _: String? = try sut.getValue(forKey: key)
                    }.value
                }
            }
            try await group.waitForAll()
        }
        let value: String? = try sut.getValue(forKey: key)
        #expect(value != nil)
    }

    @Test func concurrentAccessUsingGCD() async throws {
        let sut = DiskCache(), taskCount = 50
        let group = DispatchGroup(), queue = DispatchQueue(label: "cache.concurrent", attributes: .concurrent)

        for i in 0 ..< taskCount {
            group.enter()
            queue.async {
                do {
                    try sut.setValue("value\(i)", forKey: "key\(i)")
                } catch {
                    Issue.record(error)
                }
                group.leave()
            }
        }

        await group.wait()

        for i in 0 ..< taskCount {
            do {
                let value: String? = try sut.getValue(forKey: "key\(i)")
                #expect(value == "value\(i)")
            } catch {
                Issue.record(error)
            }
        }
    }
}

private extension DispatchGroup {
    func wait(queue: DispatchQueue = .main) async {
        await withCheckedContinuation { continuation in
            notify(queue: queue) {
                continuation.resume()
            }
        }
    }
}
