import SwiftUI

struct InfoPanelView: View {
    @Binding private var plugin: PluginsAggregate?

    init(for plugin: Binding<PluginsAggregate?>) {
        self._plugin = plugin
    }

    var body: some View {
        VStack {
            Text("INFO")
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)

            Spacer()

            if let plugin {
                VStack {
                    closeButton()

                    pluginNameSection(plugin)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Rectangle().fill(.background))
            } else {
                Text("Select plugin")
                    .foregroundStyle(.secondary)
                    .opacity(0.8)
            }

            Spacer()

        }
        .frame(width: 275)
    }

    private func closeButton() -> some View {
        Button("", systemImage: "xmark") {
            withAnimation { plugin = nil }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 4)
    }

    private func pluginNameSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            Text("Plugin name")
                .foregroundStyle(.secondary)

            Text(plugin.name)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
}
