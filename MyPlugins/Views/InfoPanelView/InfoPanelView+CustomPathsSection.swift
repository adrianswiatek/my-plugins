import SwiftData
import SwiftUI

extension InfoPanelView {
    struct CustomPathsSection: View {
        @Environment(\.modelContext) private var modelContext

        @State private var hoveredPath: PluginPath?
        @State private var isAddingShown: Bool = false

        @Binding private var hoveredUrl: URL?

        @Query(animation: .easeInOut) private var pathModels: [PluginPath]

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

                    button(systemImage: "plus", action: toggle($isAddingShown))
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.pink.opacity(0.05))
                )
                .padding(.bottom, 8)

                ForEach(paths) { path in
                    VStack(alignment: .leading) {
                        HStack {
                            SectionText(.title(path.name))

                            Spacer()

                            if path == hoveredPath {
                                HStack(spacing: 4) {
                                    Button(action: {}) {
                                        Image(systemName: "pencil")
                                    }
                                    .buttonStyle(.accessoryBar)

                                    Button(action: deleteHoveredPath) {
                                        Image(systemName: "trash")
                                    }
                                    .buttonStyle(.accessoryBar)
                                }
                                .offset(x: 8)
                            }
                        }
                        .frame(height: 24)

                        SectionText(.url(path.url, hoveredUrl: $hoveredUrl))
                    }
                    .onHover {
                        hoveredPath = $0 ? path : nil
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

        private func deleteHoveredPath() {
            if let hoveredPath {
                modelContext.delete(hoveredPath)
            }
        }
    }
}
