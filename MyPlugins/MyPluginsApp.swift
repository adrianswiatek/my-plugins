import SwiftUI

@main
struct MyPluginsApp: App {
    private let pluginsFinder = PluginsFinder(
        fileManager: .default
    )

    private let viewConfiguration = ViewConfiguration(
        pluginTypes: [.audioUnit, .vst3, .vst, .clap],
        listColumnWidth: 40.0
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 400)
                .environment(pluginsFinder)
                .environment(viewConfiguration)
        }
    }
}
