import Foundation

struct PluginsAggregate: Hashable, Identifiable {
    let name: String
    let items: [PluginItem]

    var id: String {
        name
    }

    func has(_ type: PluginType) -> Bool {
        items.contains { $0.type == type }
    }

    func url(forType type: PluginType) -> URL? {
        items.first { $0.type == type }.map(\.url)
    }
}
