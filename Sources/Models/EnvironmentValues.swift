import SwiftUICore

struct PersonLoaderKey: EnvironmentKey {
    nonisolated static var defaultValue: any PersonProvider {
        DataStore()
    }
}

extension EnvironmentValues {
    var personProvider: any PersonProvider {
        get { self[PersonLoaderKey.self] }
        set { self[PersonLoaderKey.self] = newValue }
    }
}
