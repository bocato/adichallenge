import SwiftUI

extension SearchBar {
    public struct Layout {
        let placeholder: String
        let cancelText: String
        
        public init(
            placeholder: String = "Search...",
            cancelText: String = "Cancel"
        ) {
            self.placeholder = placeholder
            self.cancelText = cancelText
        }
        
        public static let `default`: Self = .init()
    }
}

public struct SearchBar: View {
    // MARK: - Dependencies
    
    private let layout: Layout
    
    // MARK: - Properties
    
    @Binding public var text: String
    @State private var isEditing = false
    
    public init(
        layout: Layout = .default,
        text: Binding<String>
    ) {
        self.layout = layout
        self._text = text
    }
 
    // MARK: - UI
    
    public var body: some View {
        HStack {
            TextField(layout.placeholder, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture { isEditing = true }
 
            if isEditing {
                Button(layout.cancelText) {
                    isEditing = false
                    text = ""
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}


#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar(
                layout: .default,
                text: .constant("Search Value")
            )
        }
    }
}
#endif

