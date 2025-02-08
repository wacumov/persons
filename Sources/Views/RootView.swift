import SwiftUI

enum Destination: Hashable {
    case personDetails(Person)

    #if DEBUG
    case empty
    #endif
}

struct RootView: View {
    @State private var path = NavigationPath()

    @Environment(\.personProvider) private var provider

    var body: some View {
        NavigationStack(path: $path) {
            PersonListView { policy in
                try await provider.loadPersons(cachePolicy: policy)
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
