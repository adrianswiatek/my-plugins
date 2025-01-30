import Foundation

enum PluginType: CaseIterable, CustomStringConvertible {
    case audioUnit
    case clap
    case vst
    case vst3

    var fileSuffix: String {
        switch self {
            case .audioUnit: "component"
            case .clap: "clap"
            case .vst: "vst"
            case .vst3: "vst3"
        }
    }

    var directoryName: String {
        if case .audioUnit = self {
            return fileSuffix + "s"
        }
        return fileSuffix
    }

    var description: String {
        if case .audioUnit = self {
            return "AU"
        }
        return fileSuffix.uppercased()
    }

    static func fromUrl(_ url: URL) -> PluginType? {
        PluginType.allCases.first { $0.fileSuffix == url.pathExtension }
    }
}
