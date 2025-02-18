import SwiftData
import SwiftUI

@main
struct MyPluginsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let pluginsFinder = PluginsFinder(
        fileManager: .default
    )

    private let viewConfiguration = ViewConfiguration(
        pluginTypes: [.aax, .audioUnit, .clap, .vst, .vst3],
        listColumnWidth: 48.0,
        sortDirection: .ascending
    )

    private let commands = Commands()
    private let audioUnitService = AudioUnitService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1100, minHeight: 500)
                .environment(audioUnitService)
                .environment(commands)
                .environment(pluginsFinder)
                .environment(viewConfiguration)
                .modelContainer(for: [PluginPath.self], inMemory: true)
                .navigationTitle("My Plugins")
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Find plugin", action: commands.onFindPluginTapped)
                    .keyboardShortcut("f", modifiers: .command)
            }
        }
    }
}
