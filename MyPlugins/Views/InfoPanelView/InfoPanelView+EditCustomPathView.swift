import SwiftData
import SwiftUI

extension InfoPanelView {
    struct EditCustomPathView: View {
        @Environment(\.modelContext) private var modelContext

        @State private var isFileImporterShown: Bool
        @State private var isListOfCustomNamesShown: Bool
        @State private var isDeletePopoverShown: Bool

        @State private var name: String
        @State private var path: String

        @Binding private var pluginPath: PluginPath?

        private var isFormValid: Bool {
            !name.isEmpty && isPathValid && isFormChanged
        }

        private var isPathValid: Bool {
            !path.isEmpty && FileManager.default.fileExists(atPath: path)
        }

        private var isFormChanged: Bool {
            name != pluginPath?.name || path != pluginPath?.url.path(percentEncoded: false)
        }

        init(pluginPath: Binding<PluginPath?>) {
            self._pluginPath = pluginPath

            self.isFileImporterShown = false
            self.isListOfCustomNamesShown = false
            self.isDeletePopoverShown = false

            self.name = ""
            self.path = ""
        }

        var body: some View {
            VStack {
                Text("Edit custom path")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Form {
                    nameSection()
                    pathSection()
                }
                .padding()
                .border(.secondary.opacity(0.25), width: 0.75)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 8, trailing: 0))

                buttonsSection()
            }
            .padding()
            .frame(width: 450)
            .fileImporter(isPresented: $isFileImporterShown, allowedContentTypes: [.directory]) {
                if case .success(let url) = $0 {
                    path = url.path(percentEncoded: false)
                }
            }
            .onAppear {
                if let pluginPath {
                    name = pluginPath.name
                    path = pluginPath.url.path(percentEncoded: false)
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

        private func buttonsSection() -> some View {
            HStack {
                Button(role: .cancel) {
                    pluginPath = nil
                } label: {
                    Text("Cancel")
                        .frame(width: 64)
                }
                .buttonStyle(.bordered)

                Spacer()

                Button(role: .destructive, action: toggle($isDeletePopoverShown)) {
                    Text("Delete")
                        .foregroundStyle(Color(.systemRed))
                        .frame(width: 48)
                }
                .buttonStyle(.plain)
                .deletePopover(isShown: $isDeletePopoverShown, onConfirm: deletePath)

                Button {
                    updateCustomPath()
                    pluginPath = nil
                } label: {
                    Text("Update")
                        .frame(width: 64)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
            }
        }

        private func updateCustomPath() {
            let hasNameChanged = pluginPath?.name != name
            if hasNameChanged {
                pluginPath?.name = name
            }

            let url = URL(filePath: path)
            let hasUrlChanged = pluginPath?.url != url
            if hasUrlChanged {
                pluginPath?.url = url
            }

            if hasUrlChanged || hasNameChanged {
                try? modelContext.save()
            }
        }

        private func deletePath() {
            pluginPath.do(modelContext.delete)
            pluginPath = nil
        }
    }
}
