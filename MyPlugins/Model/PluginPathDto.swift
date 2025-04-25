import Foundation

struct PluginPathDto: Codable {
    let pluginName: String
    let pathName: String
    let pathUrl: URL

    static func fromPluginPath(_ pluginPath: PluginPath) -> PluginPathDto {
        PluginPathDto(
            pluginName: pluginPath.pluginName,
            pathName: pluginPath.name,
            pathUrl: pluginPath.url
        )
    }

    func toPluginPath() -> PluginPath {
        PluginPath(name: pathName, url: pathUrl, pluginName: pluginName)
    }
}
