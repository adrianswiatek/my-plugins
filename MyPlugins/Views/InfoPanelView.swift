import SwiftUI

struct InfoPanelView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @Environment(AudioUnitService.self) private var audioUnitService

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

                    Group {
                        pluginNameSection(plugin)
                        Divider()
                        pluginManufacturerSection(plugin)
                        Divider()
                        pluginTypesSection(plugin)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .padding(.bottom, 2)

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
        .padding(.top, 4)
    }

    private func pluginNameSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            Text("Name")
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)

            Text(plugin.name)
                .fontWeight(.bold)
        }
    }

    private func pluginManufacturerSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            Text("Manufacturer")
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)

            Text(audioUnitService.findManufacturerOfPlugin(plugin) ?? "[n/a]")
                .fontWeight(.bold)
        }
    }

    private func pluginTypesSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            Text("Types")
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)

            Text(sortedTypes(in: plugin).map(\.description), format: .list(type: .and))
        }
    }

    private func sortedTypes(in plugin: PluginsAggregate) -> [String] {
        viewConfiguration.pluginTypes
            .reduce([PluginType]()) { plugin.has($1) ? $0 + [$1] : $0 }
            .map(\.description)
    }
}
