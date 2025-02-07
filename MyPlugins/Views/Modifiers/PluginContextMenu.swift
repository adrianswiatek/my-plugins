import SwiftUI

struct PluginContextMenu: ViewModifier {
    private let url: URL

    init(pluginItem: PluginItem) {
        self.url = pluginItem.url
    }

    func body(content: Content) -> some View {
        content.contextMenu {
            Button("Copy File Path", action: copyUrlToClipboard)
            Button("Show in Finder", action: showInFinder)
        }
    }

    private func copyUrlToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.relativePath, forType: .string)

        let bundle = Bundle(url: url)
        let version = bundle?.infoDictionary?["CFBundleShortVersionString"] ?? "[n/a]"
    }

    private func showInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

extension View {
    func contextMenuForPlugin(_ pluginItem: PluginItem) -> some View {
        ModifiedContent(content: self, modifier: PluginContextMenu(pluginItem: pluginItem))
    }
}
