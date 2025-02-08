import SwiftUI

struct PluginUrlContextMenu: ViewModifier {
    private let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func body(content: Content) -> some View {
        content.contextMenu {
            Button("Copy", action: copyUrlToClipboard)
            Button("Show in Finder", action: showInFinder)
        }
    }

    private func copyUrlToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.relativePath, forType: .string)
    }

    private func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

extension View {
    func contextMenuForPluginUrl(_ url: URL) -> some View {
        ModifiedContent(content: self, modifier: PluginUrlContextMenu(url))
    }
}
