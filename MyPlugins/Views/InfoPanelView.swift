import SwiftUI

struct InfoPanelView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @Environment(AudioUnitService.self) private var audioUnitService

    @State private var hoveredPluginItem: PluginItem?

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
                        Divider()
                        pluginPathsSection(plugin)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 2, trailing: 16))

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(.background)
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

    private func pluginPathsSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            Text("Paths")
                .foregroundStyle(.secondary)
                .padding(.bottom, 1)

            TabView {
                ForEach(sortedItems(in: plugin), id: \.url) { pluginItem in
                    Tab {
                        Text(pluginItem.url.relativePath)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(hoveredPluginItem == pluginItem ? Color.primary.opacity(0.85) : .secondary)
                            .lineLimit(2)
                            .truncationMode(.middle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .onHover { isHovered in
                                withAnimation {
                                    hoveredPluginItem = isHovered ? pluginItem : nil
                                }
                            }
                            .contextMenuForPlugin(pluginItem)
                            .help(pluginItem.url.relativePath)
                    } label: {
                        Text(pluginItem.type.description)
                    }
                }
            }
            .tabViewStyle(.grouped)
            .frame(height: 80)
        }
    }

    private func sortedTypes(in plugin: PluginsAggregate) -> [PluginType] {
        viewConfiguration.pluginTypes.reduce([PluginType]()) { plugin.has($1) ? $0 + [$1] : $0 }
    }

    private func sortedItems(in plugin: PluginsAggregate) -> [PluginItem] {
        sortedTypes(in: plugin).compactMap { pluginType in
            plugin.items.first { $0.type == pluginType }
        }
    }
}
