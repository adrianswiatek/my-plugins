import SwiftUI

extension InfoPanelView {
    struct CustomPathRowView: View {
        @Environment(\.modelContext) private var modelContext

        @State private var hoveredPath: PluginPath?
        @State private var hoveredUrl: URL?

        @State private var editingPath: PluginPath?
        @State private var deletingPath: PluginPath?

        @State private var isDeletePopoverShown: Bool

        @State private var animationValue: Bool

        private let path: PluginPath
        private let isLast: Bool

        init(path: PluginPath, isLast: Bool) {
            self.path = path
            self.isLast = isLast
            self.isDeletePopoverShown = false
            self.animationValue = false
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    SectionText(.title(path.name))

                    Spacer()

                    if path == hoveredPath || isDeletePopoverShown || editingPath != nil {
                        HStack(spacing: 4) {
                            Button {
                                editingPath = hoveredPath
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(.accessoryBar)

                            Button {
                                deletingPath = hoveredPath
                                isDeletePopoverShown = true
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .buttonStyle(.accessoryBar)
                        }
                        .offset(x: 8)
                        .deletePopover(isShown: $isDeletePopoverShown) {
                            deletingPath.do(modelContext.delete)
                        }
                    }
                }
                .frame(height: 24)

                SectionText(.url(path.url, hoveredUrl: $hoveredUrl))
            }
            .onHover { isHovered in
                withAnimation {
                    hoveredPath = isHovered ? path : nil
                }
            }
            .sheet(item: $editingPath) { _ in
                EditCustomPathView(pluginPath: $editingPath)
            }

            if isLast == false {
                Divider()
            }
        }
    }
}
