public struct PipedriveAPIClient {
    private let client: HTTPClient

    public init(companyDomain: String, token: String) {
        client = HTTPClient(
            baseURL: "https://\(companyDomain).pipedrive.com/api",
            commonHeaders: [
                ("x-api-token", token),
            ],
            keyDecodingStrategy: .convertFromSnakeCase
        )
    }

    public func getPersons() async throws -> [Person] {
        struct Response: Decodable {
            let data: [Person]
        }
        let response: Response = try await client.get("/v1/persons")
        return response.data
    }

    public func createPerson(name: String, email: String? = nil, phone: String? = nil) async throws -> Person {
        struct Request: Encodable {
            let name: String
            let email: String?
            let phone: String?
        }
        struct Response: Decodable {
            let data: Person
        }
        let request = Request(name: name, email: email, phone: phone)
        let response: Response = try await client.post(request, to: "/v1/persons")
        return response.data
    }

    public func deletePerson(id: Person.ID) async throws {
        try await client.delete(from: "/v1/persons/\(id)")
    }
}
