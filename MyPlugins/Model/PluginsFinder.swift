import Foundation

@Observable
final class PluginsFinder {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func find(forTypes pluginTypes: [PluginType]) -> [Plugin] {
        let pluginsDirectoriesUrls: [URL] = pluginTypes.compactMap(directoryUrlToPlugin)
        let pluginItems: [PluginItem] = pluginItems(from: pluginsDirectoriesUrls)
        return plugins(from: pluginItems)
    }

    private func directoryUrlToPlugin(ofType pluginType: PluginType) -> URL? {
        let appendingToUrl: (String) -> (URL) -> URL = curry(appending)

        return switch pluginType {
            case .aax:
                url(for: .applicationSupportDirectory).map(appendingToUrl("/Avid/Audio/Plug-Ins/"))
            case .audioUnit:
                url(for: .libraryDirectory).map(appendingToUrl("/Audio/Plug-Ins/Components/"))
            case .clap, .vst, .vst3:
                url(for: .libraryDirectory).map(appendingToUrl("/Audio/Plug-Ins/\(pluginType.fileSuffix)"))
        }
    }

    private func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        fileManager.urls(for: directory, in: .localDomainMask).first
    }

    private func appending(_ value: String, to url: URL) -> URL {
        url.appendingPathComponent(value)
    }

    private func pluginItems(from urls: [URL]) -> [PluginItem] {
        guard let firstUrl = urls.first else {
            return []
        }

        if isDirectory(firstUrl) {
            let directoryUrls = try? fileManager.contentsOfDirectory(at: firstUrl, includingPropertiesForKeys: [])
            return pluginItems(from: urls.dropFirst().toArray() + directoryUrls.orEmpty())
        } else {
            let pluginItem = PluginItem.fromUrl(firstUrl).map { [$0] }.orEmpty()
            return pluginItem + pluginItems(from: urls.dropFirst().toArray())
        }
    }

    private func isDirectory(_ url: URL) -> Bool {
        // Good enough way to check whether given URL
        // is a directory containing more urls or not.
        url.pathExtension.isEmpty
    }

    private func plugins(from pluginItems: [PluginItem]) -> [Plugin] {
        Dictionary(grouping: pluginItems, by: \.name).map(Plugin.init)
    }
}
