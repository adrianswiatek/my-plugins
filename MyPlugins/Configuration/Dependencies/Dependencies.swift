import SwiftUI

protocol Dependencies {
    var audioUnitService: AudioUnitService { get }
    var commands: Commands { get }
    var exportService: ExportService { get }
    var pluginsFilter: PluginsFilter { get }
    var pluginsFinder: PluginsFinder { get }
    var pluginInfoService: PluginInfoService { get }
    var viewConfiguration: ViewConfiguration { get }
}

extension View {
    func injectDependencies(_ dependencies: Dependencies) -> some View {
        self
            .environment(dependencies.audioUnitService)
            .environment(dependencies.commands)
            .environment(dependencies.exportService)
            .environment(dependencies.pluginsFilter)
            .environment(dependencies.pluginsFinder)
            .environment(dependencies.pluginInfoService)
            .environment(dependencies.viewConfiguration)
    }
}
