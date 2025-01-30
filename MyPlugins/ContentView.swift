import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(PluginsFinder.self) private var pluginsFinder: PluginsFinder

    @State private var plugins: [PluginsAggregate] = []

    @State private var pluginTypeToFilter: PluginType?
    @State private var pluginIdToHover: String?

    private let pluginTypeColumnWidth: CGFloat = 40

    var filteredPlugins: [PluginsAggregate] {
        if let pluginTypeToFilter {
            return plugins.filter { $0.has(pluginTypeToFilter) }
        }
        return plugins
    }

    var body: some View {
        VStack {
            HStack {
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                headerButtonForPluginType(.audioUnit)
                headerButtonForPluginType(.vst3)
                headerButtonForPluginType(.vst)
                headerButtonForPluginType(.clap)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)

            List(filteredPlugins) { plugin in
                HStack {
                    Text(plugin.name)
                        .fontWeight(pluginIdToHover == plugin.id ? .medium : .regular)

                    Spacer()

                    viewForPlugin(plugin, ofType: .audioUnit)
                    viewForPlugin(plugin, ofType: .vst3)
                    viewForPlugin(plugin, ofType: .vst)
                    viewForPlugin(plugin, ofType: .clap)
                }
                .background(backgroundForPlugin(plugin))
                .onHover {
                    pluginIdToHover = $0 ? plugin.id : nil
                }
            }
            .padding(.top, -6)
        }
        .onAppear {
            plugins = pluginsFinder
                .find(forTypes: PluginType.allCases)
                .sorted { $0.name < $1.name }
        }
    }

    private func headerButtonForPluginType(_ pluginType: PluginType) -> some View {
        Button(pluginType.description) {
            pluginTypeToFilter = pluginTypeToFilter != pluginType ? pluginType : nil
        }
        .tint(pluginTypeToFilter == pluginType ? .primary : .secondary)
        .buttonStyle(.borderless)
        .fontWeight(.bold)
        .frame(width: pluginTypeColumnWidth)
    }

    @ViewBuilder
    private func viewForPlugin(_ plugin: PluginsAggregate, ofType pluginType: PluginType) -> some View {
        if plugin.has(pluginType) {
            Image(systemName: "checkmark")
                .fontWeight(pluginIdToHover == plugin.id ? .bold : .regular)
                .foregroundStyle(.green)
                .frame(width: pluginTypeColumnWidth)
        } else {
            Image(systemName: "xmark")
                .fontWeight(pluginIdToHover == plugin.id ? .light : .ultraLight)
                .foregroundStyle(.red)
                .frame(width: pluginTypeColumnWidth)
        }
    }

    @ViewBuilder
    private func backgroundForPlugin(_ plugin: PluginsAggregate) -> some View {
        if pluginIdToHover == plugin.id {
            LinearGradient(colors: [.pink.opacity(0.33), .clear], startPoint: .leading, endPoint: .trailing)
                .padding(.vertical, -4)
        } else {
            Color.clear
        }
    }
}

#Preview {
    ContentView()
}
