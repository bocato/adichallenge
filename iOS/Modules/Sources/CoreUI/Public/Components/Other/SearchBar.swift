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
        _text = text
    }

    // MARK: - UI

    public var body: some View {
        HStack {
            TextField(layout.placeholder, text: $text)
                .padding(DS.Spacing.xxSmall)
                .padding(.horizontal, DS.Spacing.base)
                .background(Color(.systemGray6))
                .cornerRadius(DS.CornerRadius.xxSmall)
                .padding(.horizontal, DS.Spacing.small)
                .onTapGesture { isEditing = true }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, DS.Spacing.base)
                        Spacer()
                    }
                )
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, DS.Spacing.base)
                            .onTapGesture { text = "" }
                            .transition(.move(edge: .trailing))
                            .opacity(text.isEmpty ? 0 : 1)
                    }
                )

            if isEditing {
                Button(layout.cancelText) {
                    isEditing = false
                    text = ""
                }
                .foregroundColor(.secondary)
                .padding(.trailing, DS.Spacing.small)
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
