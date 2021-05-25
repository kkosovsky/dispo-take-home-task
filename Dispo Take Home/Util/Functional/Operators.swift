// MARK: - ForwardApplication

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

public func |> <A, B>(x: A, f: (A) -> B) -> B { f(x) }

public func |> <A>(x: inout A, f: (inout A) -> Void) -> A {
    f(&x)
    return x
}

public func |> <A: AnyObject>(x: A, f: (A) -> Void) -> A {
    f(x)
    return x
}
