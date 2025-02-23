import Observation

@Observable
final class NameFinder {
    func find(text: String, in name: String) -> Result {
        let foundIndices = findIndices(of: prepare(text), in: prepare(name))
        return foundIndices.count != text.count ? .notFound : .found(foundIndices)
    }

    private func prepare(_ string: String) -> String {
        string.lowercased().replacingOccurrences(of: " ", with: "")
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

extension NameFinder {
    enum Result {
        case found([String.Index])
        case notFound

        var isFound: Bool {
            if case .found = self {
                return true
            }
            return false
        }
    }
}
