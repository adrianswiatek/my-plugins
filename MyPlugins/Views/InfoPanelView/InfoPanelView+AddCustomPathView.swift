import SwiftData
import SwiftUI

extension InfoPanelView {
    struct AddCustomPathView: View {
        @Environment(\.modelContext) private var modelContext

        @State private var isFileImporterShown: Bool
        @State private var isListOfCustomNamesShown: Bool

        @State private var name: String
        @State private var path: String

        @Binding private var isShown: Bool

        private var isFormValid: Bool {
            !name.isEmpty && isPathValid
        }

        private var isPathValid: Bool {
            !path.isEmpty && FileManager.default.fileExists(atPath: path)
        }

        private let plugin: Plugin

        init(plugin: Plugin, isShown: Binding<Bool>) {
            self.plugin = plugin
            self._isShown = isShown

            self.isFileImporterShown = false
            self.isListOfCustomNamesShown = false

            self.name = ""
            self.path = ""
        }

        var body: some View {
            VStack {
                Text("Add custom path")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Form {
                    nameSection()
                    pathSection()
                }
                .padding()
                .border(.secondary.opacity(0.25), width: 0.75)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))

                HStack {
                    Button(role: .cancel, action: toggle($isShown)) {
                        Text("Cancel")
                            .frame(width: 64)
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button {
                        insertCustomPath()
                        isShown.toggle()
                    } label: {
                        Text("Add")
                            .frame(width: 64)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                }
            }
            .padding()
            .frame(width: 450)
            .fileImporter(isPresented: $isFileImporterShown, allowedContentTypes: [.directory]) {
                if case .success(let url) = $0 {
                    path = url.path(percentEncoded: false)
                }
            }
        }

        private func nameSection() -> some View {
            HStack {
                Text("Name")
                    .frame(width: 36, alignment: .leading)

                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing, 4)

                Button(action: toggle($isListOfCustomNamesShown)) {
                    Image(systemName: "list.bullet.rectangle.fill")
                }
                .help("Select name")
                .popover(isPresented: $isListOfCustomNamesShown, arrowEdge: .trailing) {
                    SelectNameView(name: $name, isShown: $isListOfCustomNamesShown)
                }
            }
        }

        private func pathSection() -> some View {
            HStack {
                Text("Path")
                    .frame(width: 36, alignment: .leading)

                TextField("", text: $path)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(path.isEmpty || isPathValid ? .primary : Color.red)
                    .padding(.trailing, 4)

                Button(action: toggle($isFileImporterShown)) {
                    Image(systemName: "plus.rectangle.on.folder.fill")
                }
                .help("Select a directory")
            }
            .padding(.top, 2)
        }

        private func insertCustomPath() {
            modelContext.insert(
                PluginPath(name: name, url: URL(filePath: path), pluginName: plugin.name)
            )
            try? modelContext.save()
        }
    }
}
