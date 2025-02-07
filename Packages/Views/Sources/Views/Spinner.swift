import SwiftUI

public struct Spinner: View {
    public init() {}

    public var body: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(tint: .primary)
            )
    }
}

#if DEBUG
#Preview {
    Spinner()
}
#endif
