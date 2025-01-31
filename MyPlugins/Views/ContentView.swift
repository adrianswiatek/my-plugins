import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var plugins: [PluginsAggregate] = []
    @State private var pluginTypeToFilter: PluginType?

    var filteredPlugins: [PluginsAggregate] {
        if let pluginTypeToFilter {
            return plugins.filter { $0.has(pluginTypeToFilter) }
        }
        return plugins
    }

    var body: some View {
        VStack {
            PluginsListHeaderView(pluginTypeToFilter: $pluginTypeToFilter)
                .padding(EdgeInsets(top: 5, leading: 16, bottom: 4, trailing: 16))

            PluginsListView(plugins: filteredPlugins)
                .padding(.top, -6)

            PluginsListFooterView(plugins: filteredPlugins)
        }
        .onAppear(perform: findPlugins)
    }

    private func findPlugins() {
        plugins = pluginsFinder
            .find(forTypes: PluginType.allCases)
            .sorted { $0.name < $1.name }
    }


}

#Preview {
    ContentView()
}
