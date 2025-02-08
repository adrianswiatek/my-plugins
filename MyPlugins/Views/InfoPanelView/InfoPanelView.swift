import SwiftUI

struct InfoPanelView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @Environment(AudioUnitService.self) private var audioUnitService

    @State private var hoveredUrl: URL?

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
                ScrollView {
                    ZStack(alignment: .topTrailing) {
                        closeButton()

                        VStack {
                            Group {
                                pluginNameSection(plugin)
                                Divider()
                                pluginManufacturerSection(plugin)
                                Divider()
                                pluginTypesSection(plugin)
                                customPluginPaths(plugin)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 16)

                            Spacer()
                        }
                        .padding(.vertical)
                    }
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
        .frame(width: 450)
    }

    private func closeButton() -> some View {
        Button {
            withAnimation { plugin = nil }
        } label: {
            Image(systemName: "xmark")
        }
        .buttonStyle(.accessoryBar)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
    }

    private func pluginNameSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            SectionText(.title("Name"))
            SectionText(.value(plugin.name))
        }
    }

    private func pluginManufacturerSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            SectionText(.title("Manufacturer"))
            SectionText(.value(audioUnitService.findManufacturerOfPlugin(plugin) ?? "[n/a]"))
        }
    }

    private func pluginTypesSection(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            SectionText(.title("Types"))

            TabView {
                ForEach(sortedItems(in: plugin), id: \.url) { pluginItem in
                    Tab {
                        TypeTabView(url: pluginItem.url, hoveredUrl: $hoveredUrl)
                    } label: {
                        Text(pluginItem.type.description)
                    }
                }
            }
            .tabViewStyle(.grouped)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func sortedItems(in plugin: PluginsAggregate) -> [PluginItem] {
        viewConfiguration.pluginTypes.compactMap { pluginType in
            plugin.items.first { $0.type == pluginType }
        }
    }

    private func customPluginPaths(_ plugin: PluginsAggregate) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("CUSTOM PATHS")
                    .foregroundStyle(.secondary)

                Spacer()

                Group {
                    if plugin.items.count > 1 {
                        Button {

                        } label: {
                            Image(systemName: "pencil")
                        }

                    }

                    Button {

                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(.accessoryBar)
                .foregroundStyle(.secondary)
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(.pink.opacity(0.05))
            )
            .padding(.bottom, 8)

            ForEach(plugin.items, id: \.url) { pluginItem in
                VStack(alignment: .leading) {
                    SectionText(.title(pluginItem.type.description))
                    SectionText(.url(pluginItem.url, hoveredUrl: $hoveredUrl))
                }

                if pluginItem != plugin.items.last {
                    Divider()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.pink.opacity(0.02))
                .strokeBorder(Color.pink.opacity(0.05), lineWidth: 0.75)
        )
        .padding(.top, 4)
    }
}
