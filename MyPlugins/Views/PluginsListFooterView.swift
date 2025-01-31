import SwiftUI

struct PluginsListFooterView: View {
    @Environment(ViewConfiguration.self) private var viewConfiguration

    private let plugins: [PluginsAggregate]

    init(plugins: [PluginsAggregate]) {
        self.plugins = plugins
    }

    var body: some View {
        HStack {
            HStack {
                Text("Total:")
                    .fontWeight(.bold)

                Text(plugins.count, format: .number)
                    .fontWeight(.light)
            }

            Spacer()

            ForEach(viewConfiguration.pluginTypes) { pluginType in
                Text(plugins.filter { $0.has(pluginType) }.count, format: .number)
                    .fontWeight(.light)
                    .frame(width: viewConfiguration.listColumnWidth)
            }
        }
        .foregroundStyle(.secondary)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 6, trailing: 16))
    }
}
