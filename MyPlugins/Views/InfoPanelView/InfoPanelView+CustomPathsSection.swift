import SwiftUI

extension InfoPanelView {
    struct CustomPathsSection: View {
        @State private var isAddingShown: Bool = false
        @State private var isEditingShown: Bool = false

        @Binding private var hoveredUrl: URL?

        private let plugin: PluginsAggregate
        private let pluginPaths: [PluginPath]

        init(_ plugin: PluginsAggregate, hoveredUrl: Binding<URL?>) {
            self.plugin = plugin
            self._hoveredUrl = hoveredUrl
            self.pluginPaths = PluginPathsProvider.provide()
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("CUSTOM PATHS")
                        .foregroundStyle(.secondary)

                    Spacer()

                    if pluginPaths.count > 1 {
                        button(systemImage: "pencil", action: {})
                    }

                    button(systemImage: "plus", action: {
                        isAddingShown.toggle() }
                    )

                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.pink.opacity(0.05))
                )
                .padding(.bottom, 8)

                ForEach(PluginPathsProvider.provide()) { pluginPath in
                    VStack(alignment: .leading) {
                        SectionText(.title(pluginPath.name))
                        SectionText(.url(pluginPath.url, hoveredUrl: $hoveredUrl))
                    }

                    if pluginPath != PluginPathsProvider.provide().last {
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
            .sheet(isPresented: $isAddingShown) {
                AddCustomPathView(isShown: $isAddingShown)
            }
        }

        private func button(systemImage: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Image(systemName: systemImage)
            }
            .buttonStyle(.accessoryBar)
            .foregroundStyle(.secondary)
        }
    }
}
