import SwiftUI

struct PluginsListHeaderView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var pluginTypeToHover: PluginType?
    @Binding private var pluginTypeToFilter: PluginType?

    init(pluginTypeToFilter: Binding<PluginType?>) {
        self._pluginTypeToFilter = pluginTypeToFilter
    }

    var body: some View {
        HStack {
            Text("PLUGIN")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            Spacer()

            ForEach(viewConfiguration.pluginTypes, content: buttonForPluginType)
        }
    }

    private func buttonForPluginType(_ pluginType: PluginType) -> some View {
        Button(pluginType.description) {
            pluginTypeToFilter = pluginTypeToFilter != pluginType ? pluginType : nil
        }
        .tint(pluginTypeToFilter == pluginType ? .primary.opacity(0.9) : .secondary.opacity(0.9))
        .buttonStyle(.borderless)
        .fontWeight(.bold)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(pluginType == pluginTypeToHover ? .pink.opacity(0.1) : .clear)
                .padding(.horizontal, -6)
                .padding(.vertical, -2)
        )
        .frame(width: viewConfiguration.listColumnWidth)
        .onHover {
            pluginTypeToHover = $0 ? pluginType : nil
        }
    }
}
