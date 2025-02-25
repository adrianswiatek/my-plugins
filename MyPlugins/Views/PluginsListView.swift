import SwiftUI

struct PluginsListView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @State private var filteredPluginToHover: FilteredPlugin?
    @Binding private var selectedPlugin: Plugin?

    private let filteredPlugins: [FilteredPlugin]

    init(filteredPlugins: [FilteredPlugin], selectedPlugin: Binding<Plugin?>) {
        self.filteredPlugins = filteredPlugins
        self._selectedPlugin = selectedPlugin
    }

    var body: some View {
        List(filteredPlugins) { filteredPlugin in
            HStack {
                Text(filteredPlugin.attributedName())

                Spacer()

                ForEach(viewConfiguration.pluginTypes) { pluginType in
                    viewForPlugin(filteredPlugin.plugin, ofType: pluginType)
                }
            }
            .opacity(opacityForPlugin(filteredPlugin))
            .background(backgroundForPlugin(filteredPlugin))
            .onTapGesture(perform: selectPlugin(filteredPlugin))
            .onHover(perform: highlightPlugin(filteredPlugin))
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
    private func backgroundForPlugin(_ filteredPlugin: FilteredPlugin) -> some View {
        let linearGradientForColor: (Color) -> some View = {
            LinearGradient(colors: [$0, .clear], startPoint: .leading, endPoint: .trailing)
                .padding(.vertical, -4)
        }

        if isPluginHovered(filteredPlugin) {
            linearGradientForColor(.pink.opacity(0.35))
        } else if isPluginSelected(filteredPlugin) {
            linearGradientForColor(.pink.opacity(0.20))
        }
    }

    private func highlightPlugin(_ filteredPlugin: FilteredPlugin) -> (Bool) -> Void {
        { filteredPluginToHover = $0 ? filteredPlugin : nil }
    }

    private func selectPlugin(_ filteredPlugin: FilteredPlugin) -> () -> Void {
        { withAnimation(.easeInOut(duration: 0.1)) { selectedPlugin = filteredPlugin.plugin } }
    }

    private func opacityForPlugin(_ filteredPlugin: FilteredPlugin) -> Double {
        isPluginHovered(filteredPlugin) || isPluginSelected(filteredPlugin) ? 1.0 : 0.75
    }

    private func isPluginSelected(_ filteredPlugin: FilteredPlugin) -> Bool {
        filteredPlugin.plugin == selectedPlugin
    }

    private func isPluginHovered(_ filteredPlugin: FilteredPlugin) -> Bool {
        filteredPlugin == filteredPluginToHover
    }
}
