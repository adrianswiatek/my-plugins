import SwiftData
import SwiftUI

extension InfoPanelView {
    struct CustomPathsSection: View {
        @State private var isAddingShown: Bool = false
        @State private var isEditingShown: Bool = false

        @Binding private var hoveredUrl: URL?

        @Query private var pathModels: [PluginPath]

        var paths: [PluginPath] {
            pathModels
                .filter { $0.pluginId == plugin.id }
                .sorted { $0.name < $1.name }
        }

        private let plugin: Plugin

        init(_ plugin: Plugin, hoveredUrl: Binding<URL?>) {
            self.plugin = plugin
            self._hoveredUrl = hoveredUrl
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("CUSTOM PATHS")
                        .foregroundStyle(.secondary)

                    Spacer()

                    if !paths.isEmpty {
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

                ForEach(paths) { path in
                    VStack(alignment: .leading) {
                        SectionText(.title(path.name))
                        SectionText(.url(path.url, hoveredUrl: $hoveredUrl))
                    }

                    if path != paths.last {
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
                AddCustomPathView(plugin: plugin, isShown: $isAddingShown)
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
