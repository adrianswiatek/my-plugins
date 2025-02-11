import Foundation
import Observation

@Observable
final class ViewConfiguration {
    let pluginTypes: [PluginType]
    let listColumnWidth: CGFloat

    var sortDirection: SortDirection

    init(pluginTypes: [PluginType], listColumnWidth: CGFloat, sortDirection: SortDirection) {
        self.pluginTypes = pluginTypes
        self.listColumnWidth = listColumnWidth
        self.sortDirection = sortDirection
    }

    func sortPlugins(firstPlugin: Plugin, secondPlugin: Plugin) -> Bool {
        firstPlugin.name.caseInsensitiveCompare(secondPlugin.name) == sortDirection.asComparisonResult
    }
}

extension ViewConfiguration {
    enum SortDirection {
        case ascending
        case descending

        var asComparisonResult: ComparisonResult {
            switch self {
                case .ascending: .orderedAscending
                case .descending: .orderedDescending
            }
        }
    }
}
