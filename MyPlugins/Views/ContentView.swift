import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var plugins: [Plugin] = []
    @State private var pluginNameToFilter: String = ""
    @State private var pluginTypeToFilter: PluginType?
    @State private var selectedPlugin: Plugin?

    var filteredPlugins: [Plugin] {
        plugins.filter(canShowPluginBasedOnType).filter(canShowPluginBaseOnName)
    }

    var body: some View {
        HStack {
            VStack {
                PluginsListHeaderView(typeToFilter: $pluginTypeToFilter, nameToFilter: $pluginNameToFilter)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 3, trailing: 16))

                PluginsListView(plugins: filteredPlugins, selectedPlugin: $selectedPlugin)
                    .padding(.top, -6)

                PluginsListFooterView(plugins: filteredPlugins)
            }

            Divider()

            InfoPanelView(for: $selectedPlugin)
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 20, trailing: 8))
        }
        .onAppear(perform: findPlugins)
    }

    private func findPlugins() {
        plugins = pluginsFinder
            .find(forTypes: PluginType.allCases)
            .sorted(by: viewConfiguration.sortPlugins)
    }

    private func canShowPluginBasedOnType(_ plugin: Plugin) -> Bool {
        pluginTypeToFilter.map { plugin.has($0) } ?? true
    }

    private func canShowPluginBaseOnName(_ plugin: Plugin) -> Bool {
        pluginNameToFilter.isEmpty || plugin.name.localizedCaseInsensitiveContains(pluginNameToFilter)
    }
}
