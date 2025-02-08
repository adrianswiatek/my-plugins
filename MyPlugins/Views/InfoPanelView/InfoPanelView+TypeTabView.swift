import SwiftUI

extension InfoPanelView {
    struct TypeTabView: View {
        @Binding private var hoveredUrl: URL?

        private let url: URL

        init (url: URL, hoveredUrl: Binding<URL?>) {
            self.url = url
            self._hoveredUrl = hoveredUrl
        }

        var body: some View {
            VStack(alignment: .leading) {
                pluginVersionSection()
                Divider()
                pluginPathSection()
            }
            .padding(8)
        }

        private func pluginVersionSection() -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Version"))
                SectionText(.value(pluginVersions()))
            }
            .padding(4)
        }

        private func pluginPathSection() -> some View {
            VStack(alignment: .leading) {
                SectionText(.title("Path"))
                SectionText(.url(url, hoveredUrl: $hoveredUrl))
            }
            .padding(4)
        }

        private func pluginVersions() -> String {
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
                    return "[n/a]"
            }
        }
    }
}
