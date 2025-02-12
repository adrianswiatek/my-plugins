import SwiftUI

extension View {
    func deletePopover(isShown: Binding<Bool>, onConfirm: @escaping () -> Void) -> some View {
        ModifiedContent(content: self, modifier: DeletePopover(isShown: isShown, onConfirm: onConfirm))
    }
}

private struct DeletePopover: ViewModifier {
    @Binding private var isShown: Bool

    private let onConfirm: () -> Void

    init(isShown: Binding<Bool>, onConfirm: @escaping () -> Void) {
        self._isShown = isShown
        self.onConfirm = onConfirm
    }

    func body(content: Content) -> some View {
        content.popover(isPresented: $isShown, arrowEdge: .trailing) {
            VStack(spacing: 0) {
                Text("Are you sure")
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.secondary.opacity(0.1))
                    )

                VStack(spacing: 4) {
                    Button(role: .cancel, action: toggle($isShown)) {
                        Text("No")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.accessoryBar)

                    Button(role: .destructive, action: confirm) {
                        Text("Yes")
                            .foregroundStyle(Color(.systemRed))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.accessoryBar)
                }
                .padding(8)
            }
            .frame(width: 100)
        }
    }

    private func confirm() {
        isShown.toggle()
        onConfirm()
    }
}
