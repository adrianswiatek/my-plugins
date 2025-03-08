import SwiftData
import SwiftUI

@main
struct MyPluginsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let dependencies: Dependencies = ProductionDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1100, minHeight: 500)
                .injectDependencies(dependencies)
                .modelContainer(for: [PluginPath.self], inMemory: false)
                .navigationTitle("My Plugins")
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Find plugin", action: dependencies.commands.onFindPluginTap)
                    .keyboardShortcut("f", modifiers: .command)
            }
            CommandGroup(after: .newItem) {
                Button("Refresh", action: dependencies.commands.onRefreshTap)
                    .keyboardShortcut("r", modifiers: .command)
            }
        }
    }
}
