import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder: PluginsFinder

    @State private var plugins: [PluginsAggregate] = []

    var body: some View {
        List(plugins) { plugin in
            HStack {
                Text(plugin.name)
                Spacer()
                Text(plugin.items.count, format: .number)
            }
            .listStyle(.bordered)
        }
        .onAppear {
            plugins = pluginsFinder
                .find(forTypes: PluginType.allCases)
                .sorted { $0.name < $1.name }
        }
    }
}

#Preview {
    ContentView()
}
