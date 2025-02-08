public extension Person {
    func getPrimaryContact(_ keyPath: KeyPath<Self, [Self.Contact]?>) -> String? {
        guard let contact = self[keyPath: keyPath] else {
            return nil
        }
        var output: String?
        for item in contact {
            if item.primary == true {
                return item.value
            }
            if !item.value.isEmpty, output == nil {
                output = item.value
            }
        }
        return output
    }
}
