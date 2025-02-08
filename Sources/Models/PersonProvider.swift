protocol PersonProvider {
    @MainActor
    func loadPersons(cachePolicy: CachePolicy) async throws -> [Person]
}
