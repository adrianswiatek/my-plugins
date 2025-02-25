import Foundation
import SwiftData

@Model
final class PluginPath: Identifiable {
    var name: String
    var url: URL
    var pluginName: String

    init(name: String, url: URL, pluginName: String) {
        self.name = name
        self.url = url
        self.pluginName = pluginName
    }
}
