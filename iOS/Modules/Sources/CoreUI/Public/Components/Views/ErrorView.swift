import SwiftUI

extension ErrorView {
    public typealias Data = InformationView.Data
    public typealias ActionButton = InformationView.ActionButton
}
extension ErrorView.Data {
    public static let `default`: Self = .init(
        title: L10n.ErrorView.title,
        subtitle: L10n.ErrorView.subtitle
    )
}
public struct ErrorView: View {
    // MARK: - Properties
    
    private let data: Data
    private let retryButton: ActionButton
    
    // MARK: - Initialization
    
    public init(
        data: Data = .default,
        onRetry: @escaping () -> Void
    ) {
        self.data = data
        self.retryButton = .init(
            text: L10n.ErrorView.Button.text,
            action: onRetry
        )
    }
    
    // MARK: - UI
    
    public var body: some View {
        InformationView(
            data: data,
            actionButton: retryButton
        )
    }
}

