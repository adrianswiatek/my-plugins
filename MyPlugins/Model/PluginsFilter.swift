import Observation

@Observable
final class PluginsFilter {
    func filter(_ plugins: [Plugin], byType type: PluginType?, andQuery query: String) -> [FilteredPlugin] {
        plugins
            .compactMap(pluginOfType(type))
            .compactMap(pluginOfQuery(query))
            .compactMap(FilteredPlugin.init)
    }

    private func pluginOfType(_ type: PluginType?) -> (Plugin) -> Plugin? {
        return { plugin in
            type.map { type in plugin.has(type) ? plugin : nil } ?? plugin
        }
    }

    private func pluginOfQuery(_ query: String) -> (Plugin) -> (Plugin, [String.Index])? {
        let prepare: (String) -> String = { $0.lowercased().replacingOccurrences(of: " ", with: "") }
        return { [weak self] plugin in
            let foundIndices = self?.findIndices(of: prepare(query), in: prepare(plugin.name)) ?? []
            return foundIndices.count == query.count ? (plugin, foundIndices) : nil
        }
    }

    private func findIndices(of text: String, in name: String, foundIndex: String.Index? = nil) -> [String.Index] {
        guard !text.isEmpty, !name.isEmpty else { return [] }

        let indexOfCharacter = foundIndex
            .map { name.index(after: $0) }
            .map { name[$0...] }
            .or(default: .SubSequence(stringLiteral: name))
            .firstIndex(of: text[text.startIndex])

        guard let indexOfCharacter else { return [] }

        let charactersToFind = String(text[text.index(after: text.startIndex)...])
        return [indexOfCharacter] + findIndices(of: charactersToFind, in: name, foundIndex: indexOfCharacter)
    }
}

extension PluginsFilter {
    struct FilteredPlugin {
        let plugin: Plugin
        let nameIndices: [String.Index]
    }
}
