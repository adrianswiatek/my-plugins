import SwiftUI

func toggle(_ binding: Binding<Bool>) -> () -> Void {
    { binding.wrappedValue.toggle() }
}

func toggle(_ binding: Binding<Bool>, if condition: Bool) -> () -> Void {
    { condition ? toggle(binding)() : () }
}
