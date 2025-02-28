import Observation

@Observable
final class Commands {
    var onFindPluginTap: () -> Void = { }
    var onRefreshTap: () -> Void = { }
}
