import SwiftUI

extension InfoPanelView {
    struct TypeTabView: View {
        @Binding private var hoveredPluginPath: PluginItem?

        private let pluginItem: PluginItem

        init (pluginItem: PluginItem, hoveredPluginPath: Binding<PluginItem?>) {
            self.pluginItem = pluginItem
            self._hoveredPluginPath = hoveredPluginPath
        }

        var body: some View {
            VStack(alignment: .leading) {
                pluginVersionSection()
                Divider()
                pluginPathSection()
            }
            .padding(8)
        }

        private func pluginVersionSection() -> some View {
            VStack(alignment: .leading) {
                Text("Version")
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 1)

                Text(pluginVersions())
            }
            .padding(4)
        }

        private func pluginPathSection() -> some View {
            VStack(alignment: .leading) {
                Text("Path")
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 1)

                Text(pluginItem.url.relativePath)
                    .font(.system(size: 12, design: .monospaced))
                    .opacity(hoveredPluginPath == pluginItem ? 1 : 0.75)
                    .lineLimit(2)
                    .truncationMode(.middle)
                    .contextMenuForPlugin(pluginItem)
                    .help(pluginItem.url.relativePath)
                    .onHover { isHovered in
                        withAnimation {
                            hoveredPluginPath = isHovered ? pluginItem : nil
                        }
                    }
            }
            .padding(4)
        }

        private func pluginVersions() -> String {
            let bundle = Bundle(url: pluginItem.url)
            let infoDictionary = bundle?.infoDictionary
            let bundleVersion = infoDictionary?["CFBundleVersion"] as? String
            let bundleShortVersion = infoDictionary?["CFBundleShortVersionString"] as? String

            switch (bundleVersion, bundleShortVersion) {
                case (let version?, nil):
                    return version
                case (nil, let shortVersion?):
                    return shortVersion
                case (let version?, let shortVersion?) where version.count < shortVersion.count:
                    return version
                case (_, let shortVersion?):
                    return shortVersion
                case (.none, .none):
                    return "[n/a]"
            }
        }
    }
}
