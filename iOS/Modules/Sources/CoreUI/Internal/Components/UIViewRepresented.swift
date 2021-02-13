import SwiftUI

struct UIViewRepresented<UIViewType>: UIViewRepresentable where UIViewType: UIView {
    let makeUIView: (Context) -> UIViewType
    let updateUIView: (UIViewType, Context) -> Void = { _, _ in }

    func makeUIView(context: Context) -> UIViewType {
        makeUIView(context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateUIView(uiView, context)
    }
}
