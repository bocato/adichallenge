import SwiftUI

// SwiftUI doesn't have a view for activity indicators, so we make `UIActivityIndicatorView`
// accessible from SwiftUI.

public struct ActivityIndicator: View {
    
    public init() {}
    
    public var body: some View {
        UIViewRepresented(makeUIView: { _ in
            let view = UIActivityIndicatorView()
            view.startAnimating()
            return view
        })
    }
}
