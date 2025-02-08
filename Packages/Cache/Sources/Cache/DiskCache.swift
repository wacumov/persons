import Foundation

public struct DiskCache: Caching, @unchecked Sendable {
    private let directoryURL: URL
    private let fileManager = FileManager.default

    public static let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

    public init(directoryURL: URL = Self.cachesDirectory) {
        self.directoryURL = directoryURL
    }

    public func getValue<Value: Codable>(forKey key: String) throws -> Value? {
        let fileURL = makeFileURL(for: key)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Value.self, from: data)
    }

    public func setValue(_ value: some Codable, forKey key: String) throws {
        let fileURL = makeFileURL(for: key)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL, options: .atomic)
    }

    private func makeFileURL(for key: String) -> URL {
        directoryURL.appendingPathComponent(key)
    }
}
