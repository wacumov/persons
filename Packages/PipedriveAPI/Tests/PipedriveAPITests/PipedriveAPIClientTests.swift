import PipedriveAPI
import Testing

final class PipedriveAPIClientTests {
    private let sut = PipedriveAPIClient(companyDomain: "...", token: "...")

    @Test func getPersons() async throws {
        let persons = try await sut.getPersons()
        #expect(persons.isEmpty == false)
    }

    @Test func createAndDeletePerson() async throws {
        let person = try await sut.createPerson(name: "tester", email: "a@b.com", phone: "123456789")
        #expect(person.name == "tester")

        try await sut.deletePerson(id: person.id)
    }
}
