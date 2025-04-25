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
                .modelContainer(for: PluginPath.self, inMemory: false)
                .navigationTitle("My Plugins")
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Find plugin", action: dependencies.commands.onFindPluginTap)
                    .keyboardShortcut("f", modifiers: .command)
                Button("Refresh", action: dependencies.commands.onRefreshTap)
                    .keyboardShortcut("r", modifiers: .command)
            }
            CommandGroup(after: .newItem) {
                Divider()
                Button("Export paths", action: dependencies.commands.onExportPathsTap)
                    .keyboardShortcut("e", modifiers: .command)
            }
        }
    }
}
