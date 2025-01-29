import SwiftUI

@main
struct MyPluginsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 500)
                .environment(PluginsFinder(fileManager: .default))
        }
    }
}
