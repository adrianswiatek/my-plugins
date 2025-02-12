import SwiftData
import SwiftUI

extension InfoPanelView {
    struct CustomPathsSection: View {
        @Environment(\.modelContext) private var modelContext

        @State private var isAddingShown: Bool

        @Query(animation: .easeInOut) private var pathModels: [PluginPath]

        var paths: [PluginPath] {
            pathModels
                .filter { $0.pluginId == plugin.id }
                .sorted { $0.name < $1.name }
        }

        private let plugin: Plugin

        init(_ plugin: Plugin) {
            self.plugin = plugin
            self.isAddingShown = false
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("CUSTOM PATHS")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button(action: toggle($isAddingShown)) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.accessoryBar)
                    .foregroundStyle(.secondary)
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.pink.opacity(0.05))
                )
                .padding(.bottom, 2)

                ForEach(paths) {
                    CustomPathRowView(path: $0, isLast: $0 == paths.last)
                }
                .padding(.horizontal)
                .padding(.bottom, 2)
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
    }
}
