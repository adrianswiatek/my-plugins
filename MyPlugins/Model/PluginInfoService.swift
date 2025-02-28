import Foundation
import Observation

@Observable
final class PluginInfoService {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func creationDateOfPlugin(at url: URL) -> String {
        let creationDate: Date? = itemAttribute(.creationDate, atUrl: url)
        return creationDate.map { $0.formatted(date: .abbreviated, time: .shortened) } ?? "n/a"
    }

    func sizeOfPlugin(at url: URL) -> String {
        let fileUrls = try? fileManager.contentsOfDirectory(
            at: url.appendingPathComponent("Contents/macOS"),
            includingPropertiesForKeys: nil
        )

        let totalSize = fileUrls?
            .compactMap(curry(itemAttribute)(.size))
            .reduce(0, +)

        return totalSize.map { $0.formatted(.byteCount(style: .file)) } ?? "n/a"
    }

    func versionOfPlugin(at url: URL) -> String {
        let bundle = Bundle(url: url)
        let infoDictionary = bundle?.infoDictionary
        let bundleVersion = infoDictionary?["CFBundleVersion"] as? String
        let bundleShortVersion = infoDictionary?["CFBundleShortVersionString"] as? String

        switch (bundleVersion, bundleShortVersion) {
            case (let version?, nil):
                return version
            case (nil, let shortVersion?):
                return shortVersion
            case (let version?, let shortVersion?) where version.count < shortVersion.count:
                return version
            case (_, let shortVersion?):
                return shortVersion
            case (.none, .none):
                return "n/a"
        }
    }

    private func itemAttribute<T>(_ attribute: FileAttributeKey, atUrl url: URL) -> T? {
        let path = url.path(percentEncoded: false)
        let attributes = try? fileManager.attributesOfItem(atPath: path)
        return attributes?[attribute] as? T
    }
}
