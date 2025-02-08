import SwiftUI

extension InfoPanelView {
    struct SectionText: View {
        private let role: Role

        init(_ role: Role) {
            self.role = role
        }

        var body: some View {
            switch role {
                case .title(let text): title(text)
                case .url(let url, let hoveredUrl): SectionUrlText(for: url, hoveredUrl: hoveredUrl)
                case .value(let text): value(text)
            }
        }

        private func title(_ text: String) -> some View {
            Text(text)
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)
        }

        private func value(_ text: String) -> some View {
            Text(text)
                .bold()
        }

        enum Role {
            case title(String), value(String), url(URL, hoveredUrl: Binding<URL?>)
        }
    }
}

extension InfoPanelView.SectionText {
    private struct SectionUrlText: View {
        @Binding private var hoveredUrl: URL?
        private let url: URL

        init(for url: URL, hoveredUrl: Binding<URL?>) {
            self.url = url
            self._hoveredUrl = hoveredUrl
        }

        var body: some View {
            Text(url.relativePath)
                .font(.system(size: 12, design: .monospaced))
                .fontWeight(hoveredUrl == url ? .bold : .regular)
                .opacity(hoveredUrl == url ? 1 : 0.9)
                .lineLimit(1)
                .truncationMode(.middle)
                .contextMenuForPluginUrl(url)
                .help(url.relativePath)
                .onHover { isHovered in
                    withAnimation {
                        hoveredUrl = isHovered ? url : nil
                    }
                }
        }
    }
}
