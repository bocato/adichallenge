import SwiftUI

extension SearchBar {
    public struct Layout {
        let placeholder: String
        let cancelText: String
        
        public init(
            placeholder: String,
            cancelText: String
        ) {
            self.placeholder = placeholder
            self.cancelText = cancelText
        }
        
        public static let `default`: Self = .init(
            placeholder: L10n.SearchBar.placeholder,
            cancelText: L10n.SearchBar.cancelText
        )
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
                .padding(.horizontal, 15)
                .onTapGesture { isEditing = true }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                )
            
            if isEditing {
                Button(layout.cancelText) {
                    isEditing = false
                    text = ""
                }
                .foregroundColor(.secondary)
                .padding(.trailing, 15)
                .transition(.move(edge: .trailing))
                .animation(.easeInOut)
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

