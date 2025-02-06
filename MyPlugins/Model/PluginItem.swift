import Foundation

struct PluginItem: Hashable {
    let name: String
    let url: URL
    let type: PluginType

    static func fromUrl(_ url: URL) -> PluginItem? {
        PluginType.fromUrl(url).flatMap {
            PluginItem(name: url.deletingPathExtension().lastPathComponent, url: url, type: $0)
        }
    }
}
