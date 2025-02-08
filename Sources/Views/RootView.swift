import SwiftUI

enum Destination: Hashable {
    case personDetails(Person)

    #if DEBUG
    case empty
    #endif
}

struct RootView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            PersonListView { _ in
                // TODO: get real data in app (including debug run), test data in preview and in UI tests
                [Person(id: 0, name: "Name", email: nil, phone: nil)]
            } showDetails: { person in
                Destination.personDetails(person)
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case let .personDetails(person):
                    PersonDetailsView(person: person)
                #if DEBUG
                case .empty: EmptyView()
                #endif
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    RootView()
}
#endif
