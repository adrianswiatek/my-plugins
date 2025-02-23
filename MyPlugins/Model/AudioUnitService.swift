import Foundation
import AVFAudio

@Observable
final class AudioUnitService {
    private var allAudioUnitComponents: [AVAudioUnitComponent] = []

    init() {
        let allComponentsDescription = AudioComponentDescription(
            componentType: 0,
            componentSubType: 0,
            componentManufacturer: 0,
            componentFlags: 0,
            componentFlagsMask: 0
        )

        allAudioUnitComponents = AVAudioUnitComponentManager.shared().components(
            matching: allComponentsDescription
        )
    }

    func findManufacturerOfPlugin(_ plugin: Plugin) -> String? {
        let component = componentByName(of: plugin) ?? componentByUrl(of: plugin)
        return component?.manufacturerName
    }

    private func componentByName(of plugin: Plugin) -> AVAudioUnitComponent? {
        let preparedToCompare: (String) -> String = { string in
            string
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "_", with: "")
                .lowercased()
        }
        return allAudioUnitComponents.first { component in
            preparedToCompare(plugin.name).contains(preparedToCompare(component.name))
        }
    }

    private func componentByUrl(of plugin: Plugin) -> AVAudioUnitComponent? {
        allAudioUnitComponents.first { $0.componentURL == plugin.url(forType: .audioUnit) }
    }
}
