import SwiftUI
import UIKit

public struct TextView: UIViewRepresentable {
    // MARK: - Properties
    
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    
    // MARK: - Initialization
    
    public init(
        text: Binding<String>,
        textStyle: Binding<UIFont.TextStyle>
    ) {
        self._text = text
        self._textStyle = textStyle
    }
    
    // MARK: - UIViewRepresentable
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    // MARK: - Coordinator
    
    public final class Coordinator: NSObject, UITextViewDelegate {
        public var text: Binding<String>

        public init(_ text: Binding<String>) {
            self.text = text
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}
