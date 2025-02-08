import SwiftUI
import Views

struct PersonListView: View {
    let loadPersons: (CachePolicy) async throws -> [Person]
    let showDetails: (Person) -> Destination

    var body: some View {
        AsyncContentView(load: loadPersons, makeContainerType: { persons in
            guard let persons else {
                return .scroll
            }
            return persons.isEmpty ? .scroll : .list
        }) { persons in
            if persons.isEmpty {
                EmptyListView()
            } else {
                ForEach(persons) { person in
                    NavigationLink(value: showDetails(person)) {
                        PersonRowView(person: person)
                    }
                }
            }
        }
        .navigationTitle("Persons")
    }
}

private struct PersonRowView: View {
    let person: Person

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                let title = title
                Text(title.name)
                    .font(.system(.body, weight: .medium))
                    .foregroundStyle(title.color)
                if let email = person.email {
                    Text(email)
                        .font(.system(.callout))
                        .foregroundStyle(Color.secondary)
                }
            }
            Spacer()
        }
        .contentShape(Rectangle())
    }

    private var title: (name: String, color: Color) {
        if person.name.isEmpty {
            ("Anonymous, id: \(person.id)", Color.secondary)
        } else {
            (person.name, .primary)
        }
    }
}

private struct EmptyListView: View {
    var body: some View {
        Text("No persons found")
            .font(.system(.headline))
            .foregroundStyle(Color.secondary)
            .padding()
    }
}

#if DEBUG
private extension PersonListView {
    init(_ persons: [Person], canThrowError: Bool = false) {
        self.init { _ in
            try await Task.sleep(for: .seconds(1))
            if canThrowError, Bool.random() {
                throw CocoaError(.coderValueNotFound)
            }
            return persons
        } showDetails: { _ in .empty }
    }
}

private let persons = MockPersonProvider().testData

#Preview("Non-empty") {
    NavigationStack {
        PersonListView(persons)
    }
}

#Preview("Empty") {
    NavigationStack {
        PersonListView([])
    }
}

#Preview("Can throw error") {
    NavigationStack {
        PersonListView(persons, canThrowError: true)
    }
}
#endif
