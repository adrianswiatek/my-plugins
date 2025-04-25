import AVFAudio
import AudioUnit
import SwiftUI

struct ContentView: View {
    @Environment(Commands.self) private var commands
    @Environment(ExportService.self) private var exportService
    @Environment(PluginsFinder.self) private var pluginsFinder
    @Environment(PluginsFilter.self) private var pluginsFilter
    @Environment(ViewConfiguration.self) private var viewConfiguration

    @State private var plugins: [Plugin] = []
    @State private var pluginNameToFilter: String = ""
    @State private var pluginTypeToFilter: PluginType?
    @State private var selectedPlugin: Plugin?

    @State private var isExportConfirmationShown: Bool = false
    @State private var isExportErrorShown: Bool = false
    @State private var exportingError: ExportService.Error?

    private var filteredPlugins: [FilteredPlugin] {
        pluginsFilter.filter(plugins, byType: pluginTypeToFilter, andQuery: pluginNameToFilter)
    }

    var body: some View {
        HStack {
            VStack {
                PluginsListHeaderView(typeToFilter: $pluginTypeToFilter, nameToFilter: $pluginNameToFilter)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 3, trailing: 16))

                PluginsListView(filteredPlugins: filteredPlugins, selectedPlugin: $selectedPlugin)
                    .padding(.top, -6)

                PluginsListFooterView(plugins: filteredPlugins.map(\.plugin))
            }

            Divider()

            InfoPanelView(for: $selectedPlugin)
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 20, trailing: 8))
        }
        .alert("Paths successfully exported!", isPresented: $isExportConfirmationShown, actions: { })
        .alert(isPresented: $isExportErrorShown, error: exportingError, actions: { })
        .onAppear {
            commands.onRefreshTap = {
                plugins = pluginsFinder
                    .find(forTypes: PluginType.allCases)
                    .sorted(by: viewConfiguration.sortPlugins)
                pluginNameToFilter = ""
                pluginTypeToFilter = nil
                selectedPlugin = nil
            }
            commands.onRefreshTap()

            commands.onExportPathsTap = exportFile
        }
    }

    private func exportFile() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "MyPlugins"
        savePanel.title = "Export Paths"
        savePanel.allowedContentTypes = [.json]

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                Task {
                    do {
                        try exportService.exportPaths(to: url)
                        isExportConfirmationShown = true
                    } catch let error as ExportService.Error {
                        exportingError = error
                        isExportErrorShown = true
                    }
                }
            }
        }
    }
}
