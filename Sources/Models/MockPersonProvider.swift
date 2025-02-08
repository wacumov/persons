#if DEBUG
final class MockPersonProvider: PersonProvider {
    let testData: [Person] = [
        Person(id: 0, name: "Ann Smith", email: "a.s@c.com", phone: nil),
        Person(id: 1, name: "Bob Jones", email: "bob.jones@c.com", phone: "+1899202000"),
        Person(id: 2, name: "Clarice Thompson", email: nil, phone: nil),
        Person(id: 3, name: "", email: nil, phone: nil),
    ]

    func loadPersons(cachePolicy _: CachePolicy) async throws -> [Person] {
        testData
    }
}
#endif
