import SwiftUI

extension InfoPanelView {
    struct TypesSection: View {
        @Environment(ViewConfiguration.self) private var viewConfiguration

        @State var hoveredUrl: URL?

        private let plugin: Plugin

        init(_ plugin: Plugin) {
            self.plugin = plugin
        }

        var body: some View {
            VStack(alignment: .leading) {
                SectionText(.title("Types"))

                TabView {
                    ForEach(pluginItems(), id: \.url) { pluginItem in
                        Tab {
                            typeTab(for: pluginItem.url)
                        } label: {
                            Text(pluginItem.type.description)
                        }
                    }
                }
                .tabViewStyle(.grouped)
                .fixedSize(horizontal: false, vertical: true)
            }
        }

        private func pluginItems() -> [PluginItem] {
            viewConfiguration.pluginTypes.compactMap { pluginType in
                plugin.items.first { $0.type == pluginType }
            }
        }

        private func typeTab(for url: URL) -> some View {
            VStack(alignment: .leading) {
                pluginVersionSection(for: url)
                Divider()
                pluginSizeSection(for: url)
                Divider()
                pluginInstallationDateSection(for: url)
                Divider()
                pluginPathSection(for: url)
            }
            .padding(8)
        }

        private func pluginVersionSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Version"))
                SectionText(.value(pluginVersions(for: url)))
            }
            .padding(4)
        }

        private func pluginSizeSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Size"))
                SectionText(.value(pluginSize(for: url)))
            }
            .padding(4)
        }

        private func pluginInstallationDateSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Installed on"))
                SectionText(.value(creationDateOfPlugin(at: url)))
            }
            .padding(4)
        }

        private func pluginPathSection(for url: URL) -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Path"))
                SectionText(.url(url, hoveredUrl: $hoveredUrl))
            }
            .padding(4)
        }

        private func creationDateOfPlugin(at url: URL) -> String {
            do {
                let path = url.path(percentEncoded: false)
                let attributes = try FileManager.default.attributesOfItem(atPath: path)
                let creationDate = attributes[.creationDate].flatMap { $0 as? Date }
                return creationDate.map { $0.formatted(date: .abbreviated, time: .shortened) } ?? "n/a"
            } catch {
                return "n/a"
            }
        }

        private func pluginSize(for url: URL) -> String {
            let fileUrls = try? FileManager.default.contentsOfDirectory(
                at: url.appendingPathComponent("Contents/macOS"),
                includingPropertiesForKeys: nil
            )

            let totalSize = fileUrls?
                .map { $0.path(percentEncoded: false) }
                .compactMap { try? FileManager.default.attributesOfItem(atPath: $0) }
                .compactMap { $0[.size] as? UInt64 }
                .reduce(0, +)

            return totalSize.map { $0.formatted(.byteCount(style: .file)) } ?? "n/a"
        }

        private func pluginVersions(for url: URL) -> String {
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
    }
}
