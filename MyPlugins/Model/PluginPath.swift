import Foundation
import SwiftData

@Model
final class PluginPath {
    var name: String
    var url: URL
    var pluginId: String

    init(name: String, url: URL, pluginId: String) {
        self.name = name
        self.url = url
        self.pluginId = pluginId
    }
}
