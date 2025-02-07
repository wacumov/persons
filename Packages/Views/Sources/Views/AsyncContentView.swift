import SwiftUI

public enum CachePolicy: Sendable {
    case useCache
    case ignoreCache
}

public enum ContainerType {
    case scroll, list
}

public struct AsyncContentView<Content: Sendable, ContentView: View>: View {
    let load: (CachePolicy) async throws -> Content
    @ViewBuilder let makeView: (Content) -> ContentView
    private let makeContainerType: (Content?) -> ContainerType
    private let backgroundColor: Color

    @State private var content: Content?
    @State private var error: Error?

    public init(
        load: @escaping (CachePolicy) async throws -> Content,
        makeContainerType: @escaping (Content?) -> ContainerType = { _ in .scroll },
        backgroundColor: Color = .systemGroupedBackground,
        @ViewBuilder makeView: @escaping (Content) -> ContentView
    ) {
        self.load = load
        self.makeContainerType = makeContainerType
        self.backgroundColor = backgroundColor
        self.makeView = makeView
    }

    public var body: some View {
        GeometryReader { proxy in
            Group {
                let containerType: ContainerType =
                    makeContainerType(content)
                switch containerType {
                case .scroll:
                    ScrollView {
                        contentGroup(minHeight: proxy.size.height)
                    }
                case .list:
                    List {
                        contentGroup(minHeight: 0)
                    }
                }
            }
            .background(backgroundColor)
            .scrollContentBackground(.hidden)
            .refreshable {
                if content != nil || error != nil {
                    await loadContent(.ignoreCache)
                }
            }
            .task {
                await loadContent(.useCache)
            }
        }
    }

    @ViewBuilder
    private func contentGroup(minHeight: CGFloat) -> some View {
        Group {
            if let content {
                makeView(content)
            } else if let error {
                ErrorView(error) {
                    self.error = nil
                    Task { await loadContent(.ignoreCache) }
                }
            } else {
                Spinner().padding()
            }
        }
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .center)
    }

    private func loadContent(_ policy: CachePolicy) async {
        let oldContent = content
        do {
            let newContent = try await load(policy)
            withAnimation {
                content = newContent
                error = nil
            }
        } catch is CancellationError {
            content = oldContent
        } catch {
            withAnimation {
                self.error = error
                content = nil
            }
        }
    }
}

public extension AsyncContentView where Content == [Any] {}

#if DEBUG
private actor AsyncContentProvider {
    private var throwError = false
    func getContent(_ cachePolicy: CachePolicy) async throws -> String {
        defer {
            throwError.toggle()
        }
        switch cachePolicy {
        case .useCache:
            return "Cached Value"
        case .ignoreCache:
            try await Task.sleep(for: .seconds(2))
            if throwError {
                throw CocoaError(.coderValueNotFound)
            }
            return "Fresh Value"
        }
    }
}

private let provider = AsyncContentProvider()

@available(iOS 17.0, macOS 14.0, *)
#Preview {
    AsyncContentView { cachePolicy in
        try await provider.getContent(cachePolicy)
    } makeView: { content in
        VStack {
            Text(content).font(.largeTitle)
            Text("(pull to refresh)").font(.body)
        }
    }
}
#endif
