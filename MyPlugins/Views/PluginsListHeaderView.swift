import SwiftUI

struct PluginsListHeaderView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration
    @Environment(Commands.self) private var commands

    @State private var isSearchFieldVisible: Bool = false
    @FocusState private var isSearchFieldFocused: Bool

    @Binding private var typeToFilter: PluginType?
    @Binding private var nameToFilter: String

    init(typeToFilter: Binding<PluginType?>, nameToFilter: Binding<String>) {
        self._typeToFilter = typeToFilter
        self._nameToFilter = nameToFilter
    }

    var body: some View {
        HStack {
            if isSearchFieldVisible {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Plugin name", text: $nameToFilter)
                        .textFieldStyle(.plain)
                        .focused($isSearchFieldFocused)
                }
                .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 4) {
                    Text("PLUGIN")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)

                    Button(action: onPluginFind) {
                        Text("Find (⌘+F)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.accessoryBar)

                }
            }

            Spacer()

            ForEach(viewConfiguration.pluginTypes, content: buttonForPluginType)
        }
        .onChange(of: isSearchFieldFocused) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSearchFieldVisible = isSearchFieldFocused || !nameToFilter.isEmpty
            }
        }
        .onKeyPress(.escape) {
            isSearchFieldFocused = false
            return .handled
        }
        .onAppear {
            commands.onFindPluginTapped = onPluginFind
        }
    }

    private func buttonForPluginType(_ pluginType: PluginType) -> some View {
        Button(pluginType.description) {
            typeToFilter = typeToFilter != pluginType ? pluginType : nil
        }
        .foregroundStyle(typeToFilter == pluginType ? .primary : .secondary)
        .buttonStyle(.accessoryBar)
        .fontWeight(.bold)
        .frame(width: viewConfiguration.listColumnWidth)
    }

    private func onPluginFind() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isSearchFieldVisible = true
            isSearchFieldFocused = true
        }
    }
}
