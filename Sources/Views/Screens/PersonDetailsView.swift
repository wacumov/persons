import SwiftUI

struct PersonDetailsView: View {
    let person: Person

    var body: some View {
        let title = person.title
        let contacts = [
            ("email", person.email),
            ("phone", person.phone),
        ]
        return VStack {
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.secondary)
                .opacity(0.5)
            Text(title.name)
                .font(.largeTitle)
                .foregroundStyle(title.color)
            ForEach(contacts, id: \.0) { contact in
                if let value = contact.1 {
                    Text(value)
                        .font(.body)
                        .foregroundStyle(Color.secondary)
                }
            }
            Spacer()
            Text("id: \(person.id)")
                .monospaced()
                .font(.body)
                .foregroundStyle(Color.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemBackground.clipShape(RoundedRectangle(cornerRadius: 16)))
        .padding(40)
        .background(Color.systemGroupedBackground)
    }
}

#if DEBUG
#Preview {
    PersonDetailsView(person: MockPersonProvider().testData[0])
}
#endif
