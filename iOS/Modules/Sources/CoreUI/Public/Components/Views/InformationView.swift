import SwiftUI

extension InformationView {
    public struct Data {
        public let title: String
        public let subtitle: String
    }
    
    public struct ActionButton {
        public let text: String
        public let action: () -> Void
    }
}

public struct InformationView: View {
    // MARK: - Properties
    
    private let data: Data
    private let actionButton: ActionButton?
    
    // MARK: - Initialization
    
    public init(
        data: Data = .default,
        actionButton: ActionButton? = nil
    ) {
        self.data = data
        self.actionButton = actionButton
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack(spacing: DS.Spacing.base) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: DS.LayoutSize.large.width, height: DS.LayoutSize.large.height)
                .foregroundColor(.red)
            
            VStack(spacing: DS.Spacing.xSmall) {
                Text(data.title)
                    .foregroundColor(.primary)
                    .bold()
                Text(data.subtitle)
                    .foregroundColor(.primary)
            }
            .multilineTextAlignment(.center)
            
            if let actionButton = actionButton {
                Button(
                    actionButton.text,
                    action: actionButton.action
                )
            }
        }
        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center] * 1.1 }
        .padding(DS.Spacing.medium)
        .frame(
            minWidth: .zero,
            maxWidth: .infinity,
            minHeight: .zero,
            maxHeight: .infinity
        )
    }
}

