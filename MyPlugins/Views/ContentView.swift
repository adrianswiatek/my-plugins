import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var plugins: [PluginsAggregate] = []
    @State private var pluginNameToFilter: String = ""
    @State private var pluginTypeToFilter: PluginType?

    var filteredPlugins: [PluginsAggregate] {
        plugins.filter(canShowPluginBasedOnType).filter(canShowPluginBaseOnName)
    }

    var body: some View {
        VStack {
            PluginsListHeaderView(typeToFilter: $pluginTypeToFilter, nameToFilter: $pluginNameToFilter)
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 3, trailing: 16))

            PluginsListView(plugins: filteredPlugins)
                .padding(.top, -6)

            PluginsListFooterView(plugins: filteredPlugins)
        }
        .onAppear(perform: findPlugins)
    }

    private func findPlugins() {
        plugins = pluginsFinder
            .find(forTypes: PluginType.allCases)
            .sorted(by: viewConfiguration.sortPlugins)
    }

    private func canShowPluginBasedOnType(_ plugin: PluginsAggregate) -> Bool {
        pluginTypeToFilter.map { plugin.has($0) } ?? true
    }

    private func canShowPluginBaseOnName(_ plugin: PluginsAggregate) -> Bool {
        pluginNameToFilter.isEmpty || plugin.name.localizedCaseInsensitiveContains(pluginNameToFilter)
    }
}

#Preview {
    ContentView()
}
