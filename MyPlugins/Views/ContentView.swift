import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder
    @Environment(PluginsFilter.self) private var pluginsFilter
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var plugins: [Plugin] = []
    @State private var pluginNameToFilter: String = ""
    @State private var pluginTypeToFilter: PluginType?
    @State private var selectedPlugin: Plugin?

    private var filteredPlugins: [FilteredPlugin] {
        pluginsFilter.filter(plugins, byType: pluginTypeToFilter, andQuery: pluginNameToFilter)
    }

    var body: some View {
        HStack {
            VStack {
                PluginsListHeaderView(typeToFilter: $pluginTypeToFilter, nameToFilter: $pluginNameToFilter)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 3, trailing: 16))

                PluginsListView(filteredPlugins: filteredPlugins, selectedPlugin: $selectedPlugin)
                    .padding(.top, -6)

                PluginsListFooterView(plugins: filteredPlugins.map(\.plugin))
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
}
