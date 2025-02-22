final class ProductionDependencies: Dependencies {
    let audioUnitService = AudioUnitService()

    let commands = Commands()

    let pluginsFinder = PluginsFinder(
        fileManager: .default
    )

    let viewConfiguration = ViewConfiguration(
        pluginTypes: [.aax, .audioUnit, .clap, .vst, .vst3],
        listColumnWidth: 48.0,
        sortDirection: .ascending
    )
}
