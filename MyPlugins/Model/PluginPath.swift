import Foundation
import SwiftData

@Observable
final class PluginPath: Hashable, Identifiable {
    var name: String
    var url: URL

    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }

    static func == (lhs: PluginPath, rhs: PluginPath) -> Bool {
        lhs.name == rhs.name && lhs.url == rhs.url
    }
}

final class PluginPathsProvider {
    static func provide() -> [PluginPath] {
        return [
            PluginPath(name: "Factory Presets", url: URL(string: "file:///Library/Audio/Presets/u-he/Hive")!),
            PluginPath(name: "User Presets", url: URL(string: "file:///Users/adrianswiatek/Library/Audio/Presets/u-he/Hive")!),
            PluginPath(name: "Wavetables", url: URL(string: "file:///Library/Application Support/u-he/Hive/Wavetables")!),
        ]
    }
}
