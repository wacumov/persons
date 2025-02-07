import SwiftUI

public struct ErrorView: View {
    let error: Error
    let retry: () -> Void

    public init(_ error: Error, retry: @escaping () -> Void) {
        self.error = error
        self.retry = retry
    }

    public var body: some View {
        VStack {
            Spacer()
            Text(error.localizedDescription)
                .font(.title)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Retry") {
                retry()
            }
            .buttonStyle(.secondary)
        }
        .padding()
    }
}

#if DEBUG
@available(iOS 17.0, macOS 14.0, *)
#Preview {
    @Previewable @State var error: Error = CocoaError(.coreData)
    let codes: [CocoaError.Code] = [.coreData, .coderInvalidValue, .fileNoSuchFile, .fileReadTooLarge]
    ErrorView(error) {
        error = CocoaError(codes.randomElement()!)
    }
}
#endif
