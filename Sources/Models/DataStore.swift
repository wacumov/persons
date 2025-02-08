import Cache
import PipedriveAPI

actor DataStore {
    private let credentials = Secrets.getCredentials()
    private lazy var client = PipedriveAPIClient(
        companyDomain: credentials.companyDomain,
        token: credentials.token
    )

    private lazy var loader = DataLoader(cache: DiskCache()) { _ in
        try await self.client.getPersons()
    }
}

extension DataStore: PersonProvider {
    func loadPersons(cachePolicy: CachePolicy) async throws -> [Person] {
        let policy: Cache.CachePolicy = switch cachePolicy {
        case .useCache: .useCache
        case .ignoreCache: .ignoreCache
        }
        let persons = try await loader.get(key: "persons", policy: policy)
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

private extension Secrets {
    static func getCredentials() -> (companyDomain: String, token: String) {
        let secrets = Secrets.get()
        let components = secrets.components(separatedBy: ",")
        guard components.count == 2 else {
            fatalError("""
            Missing credentials!
            Run: make auth credentials=companydomain,apikey
            See README.md
            """)
        }
        return (components[0], components[1])
    }
}
