import SwiftUI

struct PluginsListView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var pluginIdToHover: String?

    private let plugins: [PluginsAggregate]

    init(plugins: [PluginsAggregate]) {
        self.plugins = plugins
    }

    var body: some View {
        List(plugins) { plugin in
            HStack {
                Text(plugin.name)

                Spacer()

                ForEach(viewConfiguration.pluginTypes) { pluginType in
                    viewForPlugin(plugin, ofType: pluginType)
                }
            }
            .opacity(opacityForPlugin(plugin))
            .background(backgroundForPlugin(plugin))
            .onHover(perform: highlightPlugin(plugin))
        }
    }

    @ViewBuilder
    private func viewForPlugin(_ plugin: PluginsAggregate, ofType pluginType: PluginType) -> some View {
        if plugin.has(pluginType) {
            Image(systemName: "checkmark")
                .foregroundStyle(.green)
                .frame(width: viewConfiguration.listColumnWidth)
        } else {
            Image(systemName: "xmark")
                .fontWeight(.light)
                .foregroundStyle(.red.opacity(0.75))
                .frame(width: viewConfiguration.listColumnWidth)
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

    private func highlightPlugin(_ plugin: PluginsAggregate) -> (Bool) -> Void {
        { pluginIdToHover = $0 ? plugin.id : nil }
    }

    private func opacityForPlugin(_ plugin: PluginsAggregate) -> Double {
        pluginIdToHover == plugin.id ? 1.0 : 0.66
    }
}
