import Foundation

#if DEBUG
extension HTTPClient {
    func printRequest(_ request: URLRequest) {
        printKeyedValues([
            (request.httpMethod!, request.url!.absoluteString),
        ], andJson: request.httpBody)
    }

    func printResponse(_ response: HTTPURLResponse, request: URLRequest, data: Data) {
        printKeyedValues([
            (request.httpMethod!, request.url!.absoluteString),
            ("response.statusCode", "\(response.statusCode)"),
        ], andJson: data)
    }

    private func printKeyedValues(_ keyedValues: [(String, String)], andJson data: Data?) {
        print("===")
        for (key, value) in keyedValues {
            print("\(key): \(value)")
        }
        if let json = data?.json {
            print(json)
        }
        print("===")
    }
}

private extension Data {
    var json: String? {
        guard let json = try? JSONSerialization.jsonObject(with: self), let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
#endif
