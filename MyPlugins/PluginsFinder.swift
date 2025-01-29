import Foundation

@Observable
final class PluginsFinder {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func find(forTypes pluginTypes: [PluginType]) -> [PluginsAggregate] {
        let libraryUrls = fileManager.urls(for: .libraryDirectory, in: .localDomainMask)
        let pluginsPath = "Audio/Plug-Ins"

        let directoriesUrls = libraryUrls.first
            .map { $0.appendingPathComponent(pluginsPath) }
            .map { pluginTypes.map(\.directoryName).map(appendingToUrl($0)) }
            .orEmpty()

        return pluginsAggregates(from: pluginItems(from: directoriesUrls))
    }

    private func appendingToUrl(_ url: URL) -> (String) -> URL {
        { url.appendingPathComponent($0) }
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

    private func pluginsAggregates(from pluginItems: [PluginItem]) -> [PluginsAggregate] {
        Dictionary(grouping: pluginItems, by: \.name).map(PluginsAggregate.init)
    }
}
