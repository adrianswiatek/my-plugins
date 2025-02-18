import Foundation

enum PluginType: CaseIterable, CustomStringConvertible {
    case aax
    case audioUnit
    case clap
    case vst
    case vst3

    var fileSuffix: String {
        switch self {
            case .aax: "aaxplugin"
            case .audioUnit: "component"
            case .clap: "clap"
            case .vst: "vst"
            case .vst3: "vst3"
        }
    }

    var description: String {
        switch self {
            case .aax: "AAX"
            case .audioUnit: "AU"
            case .clap, .vst, .vst3: fileSuffix.uppercased()
        }
    }

    static func fromUrl(_ url: URL) -> PluginType? {
        PluginType.allCases.first { $0.fileSuffix == url.pathExtension }
    }
}

extension PluginType: Identifiable {
    var id: PluginType {
        self
    }
}
