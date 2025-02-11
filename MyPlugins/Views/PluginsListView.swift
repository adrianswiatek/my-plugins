import SwiftUI

struct PluginsListView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @State private var pluginIdToHover: String?
    @Binding private var selectedPlugin: Plugin?

    private let plugins: [Plugin]

    init(plugins: [Plugin], selectedPlugin: Binding<Plugin?>) {
        self.plugins = plugins
        self._selectedPlugin = selectedPlugin
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
            .onTapGesture(perform: selectPlugin(plugin))
            .onHover(perform: highlightPlugin(plugin))
        }
    }

    @ViewBuilder
    private func viewForPlugin(_ plugin: Plugin, ofType pluginType: PluginType) -> some View {
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
    private func backgroundForPlugin(_ plugin: Plugin) -> some View {
        let linearGradientForColor: (Color) -> some View = {
            LinearGradient(colors: [$0, .clear], startPoint: .leading, endPoint: .trailing)
                .padding(.vertical, -4)
        }

        if isPluginHovered(plugin) {
            linearGradientForColor(.pink.opacity(0.35))
        } else if isPluginSelected(plugin) {
            linearGradientForColor(.pink.opacity(0.20))
        }
    }

    private func highlightPlugin(_ plugin: Plugin) -> (Bool) -> Void {
        { pluginIdToHover = $0 ? plugin.id : nil }
    }

    private func selectPlugin(_ plugin: Plugin) -> () -> Void {
        { withAnimation { selectedPlugin = plugin } }
    }

    private func opacityForPlugin(_ plugin: Plugin) -> Double {
        isPluginHovered(plugin) || isPluginSelected(plugin) ? 1.0 : 0.75
    }

    private func isPluginSelected(_ plugin: Plugin) -> Bool {
        plugin.id == selectedPlugin?.id
    }

    private func isPluginHovered(_ plugin: Plugin) -> Bool {
        plugin.id == pluginIdToHover
    }
}
