import SwiftUI

public struct EmptyContentView: View {
    // MARK: - Properties
    
    private let data: InformationView.Data
    
    // MARK: - Initialization
    
    public init(
        title: String,
        subtitle: String
    ) {
        self.data = .init(
            title: title,
            subtitle: subtitle
        )
    }
    
    // MARK: - UI
    
    public var body: some View {
        InformationView(
            data: data,
            actionButton: nil
        )
    }
}

