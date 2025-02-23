extension ArraySlice {
    func toArray() -> Array<Element> {
        Array(self)
    }
}

extension Optional {
    func orEmpty<T>() -> [T] where Wrapped == [T] {
        self ?? []
    }

    func or(default defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    func `do`(_ action: (Wrapped) throws -> Void) rethrows {
        switch self {
            case .some(let wrapped):
                try action(wrapped)
            case .none:
                return
        }
    }
}
