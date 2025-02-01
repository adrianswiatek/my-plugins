import SwiftUI

@main
struct MyPluginsApp: App {
    private let pluginsFinder = PluginsFinder(
        fileManager: .default
    )

    private let viewConfiguration = ViewConfiguration(
        pluginTypes: [.audioUnit, .vst3, .vst, .clap],
        listColumnWidth: 48.0,
        sortDirection: .ascending
    )

    private let commands: Commands = Commands()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 400)
                .environment(commands)
                .environment(pluginsFinder)
                .environment(viewConfiguration)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Find plugin", action: commands.onFindPluginTapped)
                    .keyboardShortcut("f", modifiers: .command)
            }
        }
    }
}
