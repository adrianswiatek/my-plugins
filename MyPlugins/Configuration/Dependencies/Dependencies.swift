import SwiftUI

protocol Dependencies {
    var audioUnitService: AudioUnitService { get }
    var commands: Commands { get }
    var nameFinder: NameFinder { get }
    var pluginsFinder: PluginsFinder { get }
    var viewConfiguration: ViewConfiguration { get }
}

extension View {
    func injectDependencies(_ dependencies: Dependencies) -> some View {
        self
            .environment(dependencies.audioUnitService)
            .environment(dependencies.commands)
            .environment(dependencies.nameFinder)
            .environment(dependencies.pluginsFinder)
            .environment(dependencies.viewConfiguration)
    }
}
