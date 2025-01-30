import SwiftUI

@main
struct MyPluginsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 600, minHeight: 400)
                .environment(PluginsFinder(fileManager: .default))
        }
    }
}
