import SwiftUI

extension InfoPanelView {
    struct TypesSection: View {
        @Environment(PluginInfoService.self) private var pluginInfoService
        @Environment(ViewConfiguration.self) private var viewConfiguration

        @State var hoveredUrl: URL?

        private let plugin: Plugin

        init(_ plugin: Plugin) {
            self.plugin = plugin
        }

        var body: some View {
            VStack(alignment: .leading) {
                SectionText(.title("Types"))

                TabView {
                    ForEach(pluginItems(), id: \.url) { pluginItem in
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

        private func typeTab(for url: URL) -> some View {
            VStack(alignment: .leading) {
                pluginVersionSection(for: url)
                Divider()
                pluginSizeSection(for: url)
                Divider()
                pluginInstallationDateSection(for: url)
                Divider()
                pluginPathSection(for: url)
            }
            .padding(8)
        }

        private func pluginVersionSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Version"))
                SectionText(.value(pluginInfoService.versionOfPlugin(at: url)))
            }
            .padding(4)
        }

        private func pluginSizeSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Size"))
                SectionText(.value(pluginInfoService.sizeOfPlugin(at: url)))
            }
            .padding(4)
        }

        private func pluginInstallationDateSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Installed on"))
                SectionText(.value(pluginInfoService.creationDateOfPlugin(at: url)))
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

        private func pluginItems() -> [PluginItem] {
            viewConfiguration.pluginTypes.compactMap { pluginType in
                plugin.items.first { $0.type == pluginType }
            }
        }
    }
}
