import PipedriveAPI

actor DataStore {
    private let client = PipedriveAPIClient(companyDomain: "...", token: "...")
}

extension DataStore: PersonProvider {
    func loadPersons(cachePolicy _: CachePolicy) async throws -> [Person] {
        let persons = try await client.getPersons()
        return persons.map {
            Person(
                id: $0.id,
                name: $0.name,
                email: $0.getPrimaryContact(\.email),
                phone: $0.getPrimaryContact(\.phone)
            )
        }
    }
}
