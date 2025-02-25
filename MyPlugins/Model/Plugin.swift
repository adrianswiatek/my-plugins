import Foundation

struct Plugin: Hashable {
    let name: String
    let items: [PluginItem]

    func has(_ type: PluginType) -> Bool {
        items.contains { $0.type == type }
    }

    func url(forType type: PluginType) -> URL? {
        items.first { $0.type == type }.map(\.url)
    }
}
