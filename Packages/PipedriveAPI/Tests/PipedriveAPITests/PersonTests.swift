import Foundation
import PipedriveAPI
import Testing

final class PersonTests {
    private let decoder = JSONDecoder()

    @Test func getPrimaryEmail() throws {
        let person = try decoder.decode(Person.self, from: Data("""
        {"id": 0, "name": "Name", "email": [
            { "value": "" },
            { "value": "a.b@c.de", "primary": true }
        ]}
        """.utf8))
        #expect(person.getPrimaryContact(\.email) == "a.b@c.de")
    }

    @Test func getFirstNonEmptyEmail() throws {
        let person = try decoder.decode(Person.self, from: Data("""
        {"id": 0, "name": "Name", "email": [
            { "value": "" },
            { "value": "a.b@c.de" },
            { "value": "f.g@c.dr" }
        ]}
        """.utf8))
        #expect(person.getPrimaryContact(\.email) == "a.b@c.de")
    }
}
