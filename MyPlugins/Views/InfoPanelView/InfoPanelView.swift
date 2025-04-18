import SwiftUI

struct InfoPanelView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @Environment(AudioUnitService.self) private var audioUnitService

    @Binding private var plugin: Plugin?

    init(for plugin: Binding<Plugin?>) {
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
                                TypesSection(plugin)
                                    .padding(.bottom, 8)
                                CustomPathsSection(plugin)
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
            withAnimation(.easeInOut(duration: 0.1)) { plugin = nil }
        } label: {
            Image(systemName: "xmark")
        }
        .buttonStyle(.accessoryBar)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16))
    }

    private func pluginNameSection(_ plugin: Plugin) -> some View {
        VStack(alignment: .leading) {
            SectionText(.title("Name"))
            SectionText(.value(plugin.name))
        }
    }

    private func pluginManufacturerSection(_ plugin: Plugin) -> some View {
        VStack(alignment: .leading) {
            SectionText(.title("Manufacturer"))
            SectionText(.value(audioUnitService.findManufacturerOfPlugin(plugin) ?? "[n/a]"))
        }
    }
}
