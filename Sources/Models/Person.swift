struct Person: Identifiable, Hashable {
    let id: ID
    let name: String
    let email: String?
    let phone: String?

    typealias ID = Int
}
