import Foundation

final class HTTPClient: Sendable {
    private let baseURL: String
    private let headers: [(String, String)]
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
    }

    private struct Empty: Decodable {}

    init(baseURL: String, commonHeaders: [(String, String)] = [], keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) {
        self.baseURL = baseURL
        headers = commonHeaders
        if let keyDecodingStrategy {
            decoder.keyDecodingStrategy = keyDecodingStrategy
        }
    }

    func get<T: Decodable>(
        _ path: String,
        headers: [(String, String)] = [],
        query: [(String, String)] = []
    ) async throws -> T {
        let request = try makeRequest(.GET, path: path, headers: headers, query: query)
        return try await loadData(request)
    }

    public func post<T: Decodable>(
        _ body: some Encodable,
        to path: String,
        headers: [(String, String)] = []
    ) async throws -> T {
        var request = try makeRequest(.POST, path: path, headers: headers)
        request.httpBody = try encoder.encode(body)
        return try await loadData(request)
    }

    public func delete(
        from path: String,
        headers: [(String, String)] = []
    ) async throws {
        let request = try makeRequest(.DELETE, path: path, headers: headers)
        let _: Empty = try await loadData(request)
    }

    private func makeURL(
        _ path: String,
        query: [(String, String)] = []
    ) throws -> URL {
        guard let baseURL = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        if !query.isEmpty {
            components.queryItems = query.map(URLQueryItem.init)
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }

    private func makeRequest(
        _ httpMethod: HTTPMethod,
        path: String,
        headers: [(String, String)],
        query: [(String, String)] = []
    ) throws -> URLRequest {
        let url = try makeURL(path, query: query)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        for field in ["Accept", "Content-Type"] {
            request.setValue("application/json", forHTTPHeaderField: field)
        }
        for header in headers + self.headers {
            request.setValue(header.1, forHTTPHeaderField: header.0)
        }
        return request
    }

    private func loadData<T: Decodable>(_ request: URLRequest) async throws -> T {
        #if DEBUG
        printRequest(request)
        #endif

        let (data, urlResponse): (Data, URLResponse) = try await session.data(for: request)

        guard let response = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        #if DEBUG
        printResponse(response, request: request, data: data)
        #endif

        switch response.statusCode {
        case 200 ..< 300:
            let _data = data.isEmpty ? Data("{}".utf8) : data
            do {
                return try decoder.decode(T.self, from: _data)
            } catch let error as DecodingError {
                throw ResponseDecodingError(error)
            } catch {
                throw error
            }
        default:
            throw ResponseError(statusCode: response.statusCode, message: response.description)
        }
    }
}
