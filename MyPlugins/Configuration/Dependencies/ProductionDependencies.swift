final class ProductionDependencies: Dependencies {
    let audioUnitService = AudioUnitService()
    let commands = Commands()
    let exportService = ExportService()
    let pluginsFilter = PluginsFilter()
    let pluginsFinder = PluginsFinder(fileManager: .default)
    let pluginInfoService = PluginInfoService(fileManager: .default)

    let viewConfiguration = ViewConfiguration(
        pluginTypes: [.aax, .audioUnit, .clap, .vst, .vst3],
        listColumnWidth: 48.0,
        sortDirection: .ascending
    )
}
