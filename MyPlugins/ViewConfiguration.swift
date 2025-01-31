import Foundation
import Observation

@Observable
final class ViewConfiguration {
    let pluginTypes: [PluginType]
    let listColumnWidth: CGFloat

    init(pluginTypes: [PluginType], listColumnWidth: CGFloat) {
        self.pluginTypes = pluginTypes
        self.listColumnWidth = listColumnWidth
    }
}
