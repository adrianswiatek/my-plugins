import Foundation
import SwiftData

@Observable
final class ExportService {
    private let fileManager: FileManager
    private let modelContainer: ModelContainer
    private let jsonEncoder: JSONEncoder

    init() {
        self.modelContainer = try! ModelContainer(
            for: PluginPath.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        self.fileManager = .default
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    }

    @MainActor
    func exportPaths(to url: URL) throws(ExportService.Error) {
        let pluginPaths = try execute(fetchPluginPaths(), orThrow: .fetchingFailed)
        let pluginPathDtos = pluginPaths.map(PluginPathDto.fromPluginPath)
        let dtosData = try execute(jsonEncoder.encode(pluginPathDtos), orThrow: .encodingFailed)
        try execute(dtosData.write(to: url), orThrow: .writingFailed)
    }

    @MainActor
    private func fetchPluginPaths() throws -> [PluginPath] {
        let fetchDescription = FetchDescriptor<PluginPath>()
        let pluginPaths = try modelContainer.mainContext.fetch(fetchDescription)
        return sortedPluginPaths(pluginPaths)
    }

    private func sortedPluginPaths(_ pluginPaths: [PluginPath]) -> [PluginPath] {
        pluginPaths.sorted {
            if $0.pluginName != $1.pluginName {
                $0.pluginName < $1.pluginName
            } else {
                $0.name < $1.name
            }
        }
    }

    private func execute<T>(
        _ fn: @autoclosure () throws -> T,
        orThrow error: ExportService.Error
    ) throws(ExportService.Error) -> T {
        if let result = try? fn() {
            result
        } else {
            throw error
        }
    }
}

extension ExportService {
    enum Error: LocalizedError {
        case fetchingFailed
        case encodingFailed
        case writingFailed

        var errorDescription: String? {
            switch self {
                case .fetchingFailed: "Failed to fetch plugin paths."
                case .encodingFailed: "Failed to encode plugin paths to JSON."
                case .writingFailed: "Failed to write JSON to file."
            }
        }
    }
}
