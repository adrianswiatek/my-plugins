import SwiftUI

extension InfoPanelView {
    struct SelectNameView: View {
        @Binding private var name: String
        @Binding private var isShown: Bool

        private let availableNames: [String]

        init(name: Binding<String>, isShown: Binding<Bool>) {
            self._name = name
            self._isShown = isShown

            self.availableNames = [
                "Factory Presets", "Presets", "User Presets", "Wavetables"
            ]
        }

        var body: some View {
            VStack(spacing: 0) {
                Text("Select name")
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.secondary.opacity(0.1))
                    )

                VStack(spacing: 4) {
                    ForEach(availableNames, id: \.self, content: popoverButton)
                }
                .padding(8)
            }
            .frame(width: 128)
        }

        private func popoverButton(withName name: String) -> some View {
            Button {
                self.name = name
                self.isShown.toggle()
            } label: {
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.accessoryBar)
        }
    }
}
