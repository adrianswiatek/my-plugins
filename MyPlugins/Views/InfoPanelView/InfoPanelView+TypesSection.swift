import SwiftUI

extension InfoPanelView {
    struct TypesSection: View {
        @Environment(ViewConfiguration.self) private var viewConfiguration

        @Binding var hoveredUrl: URL?

        private let plugin: Plugin

        init(_ plugin: Plugin, hoveredUrl: Binding<URL?>) {
            self.plugin = plugin
            self._hoveredUrl = hoveredUrl
        }

        var body: some View {
            VStack(alignment: .leading) {
                SectionText(.title("Types"))

                TabView {
                    ForEach(sortedItems(), id: \.url) { pluginItem in
                        Tab {
                            typeTab(for: pluginItem.url)
                        } label: {
                            Text(pluginItem.type.description)
                        }
                    }
                }
                .tabViewStyle(.grouped)
                .fixedSize(horizontal: false, vertical: true)
            }
        }

        private func sortedItems() -> [PluginItem] {
            viewConfiguration.pluginTypes.compactMap { pluginType in
                plugin.items.first { $0.type == pluginType }
            }
        }

        private func typeTab(for url: URL) -> some View {
            VStack(alignment: .leading) {
                pluginVersionSection(for: url)
                Divider()
                pluginPathSection(for: url)
            }
            .padding(8)
        }

        private func pluginVersionSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Version"))
                SectionText(.value(pluginVersions(for: url)))
            }
            .padding(4)
        }

        private func pluginPathSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Path"))
                SectionText(.url(url, hoveredUrl: $hoveredUrl))
            }
            .padding(4)
        }

        private func pluginVersions(for url: URL) -> String {
            let bundle = Bundle(url: url)
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
