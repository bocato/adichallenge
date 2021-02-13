import SwiftUI

/// A Wrapper for views that need to provide us more data than a simple `AnyView`.
public struct AnyCustomView: View {
    public typealias Body = Never
    public var body: Never {
        fatalError("Body is Unsupported here.")
    }

    let erasedView: AnyView

    /// Holds the original view, erased to `Any`
    public let typeErasedView: Any

    /// Holds an "associatedObject", to enable storing something that is directly related to a view withour exposing it's specific type.
    public internal(set) var associatedObject: Any?

    /// Initializes the wrapper, with a view and some associatedObject.
    /// - Parameters:
    ///   - view: the view to be type-erased.
    ///   - object: the object associated to the view.
    public init<V: View>(
        erasing view: V,
        withAssociatedObject object: Any? = nil
    ) {
        erasedView = .init(erasing: view)
        typeErasedView = view
        associatedObject = object
    }
}

public extension AnyCustomView {
    /// Wraps itself with `AnyView`.
    /// - Returns: Itself, wrapped by `AnyView`
    func eraseToAnyView() -> AnyView {
        erasedView
    }
}

public extension View {
    /// Wraps a View into `AnyCustomView`
    /// - Parameter object: an associatedObject to live along this view.
    /// - Returns: some View, wrapped in `AnyCustomView`.
    func eraseToAnyCustomView(
        withAssociatedObject object: AnyObject? = nil
    ) -> AnyCustomView {
        .init(erasing: self, withAssociatedObject: object)
    }
}
