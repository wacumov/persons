import SwiftUI

@main
struct PersonsApp: App {
    @State private var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.personProvider, makePersonProvider())
        }
    }

    private func makePersonProvider() -> any PersonProvider {
        if CommandLine.arguments.contains("UI_TESTS") {
            return MockPersonProvider()
        }
        return dataStore
    }
}
