import SwiftUI

func toggle(_ binding: Binding<Bool>) -> () -> Void {
    { binding.wrappedValue.toggle() }
}

func toggle(_ binding: Binding<Bool>, if condition: Bool) -> () -> Void {
    { condition ? toggle(binding)() : () }
}

func curry<A, B, C>(_ fn: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in fn(a, b) } }
}
