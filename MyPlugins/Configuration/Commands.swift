import Observation

@Observable
final class Commands {
    var onExportPathsTap: () -> Void = { }
    var onFindPluginTap: () -> Void = { }
    var onRefreshTap: () -> Void = { }
}
