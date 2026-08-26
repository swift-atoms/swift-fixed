public import Equation_Standard_Library_Integration
public import Fixed_Primitive
public import Span_Protocol

extension __Fixed: Equation.`Protocol`
where S: Span.`Protocol` & ~Copyable, S.Element: Equation.`Protocol` {

    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.span == rhs.span
    }
}
