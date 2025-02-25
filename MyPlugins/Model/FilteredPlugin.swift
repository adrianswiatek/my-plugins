import SwiftUI

struct FilteredPlugin: Equatable, Identifiable {
    let id: UUID
    let plugin: Plugin

    private let foundNameIndices: [String.Index]

    init(plugin: Plugin, foundNameIndices: [String.Index]) {
        self.plugin = plugin
        self.foundNameIndices = foundNameIndices
        self.id = UUID()
    }

    func attributedName() -> AttributedString {
        plugin.name.indices.reduce(into: AttributedString()) { result, currentIndex in
            var attributedCharacter = AttributedString("\(plugin.name[currentIndex])")
            if foundNameIndices.contains(currentIndex) {
                attributedCharacter.font = .body.weight(.black)
            }
            result += attributedCharacter
        }
    }
}
