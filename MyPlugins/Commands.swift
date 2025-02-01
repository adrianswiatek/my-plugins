import Observation

@Observable
final class Commands {
    var onFindPluginTapped: () -> Void = { }
}
