extension ArraySlice {
    func toArray() -> Array<Element> {
        Array(self)
    }
}

extension Optional {
    func orEmpty<T>() -> [T] where Wrapped == [T] {
        self ?? []
    }
}
