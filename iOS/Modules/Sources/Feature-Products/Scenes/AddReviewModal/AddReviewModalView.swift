import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import DependencyManagerInterface

struct AddReviewModalView: View {
    // MARK: - Dependencies

    private let store: Store<AddReviewModalState, AddReviewModalAction>

    // MARK: - Initialization

    init(store: Store<AddReviewModalState,  AddReviewModalAction>) {
        self.store = store
    }

    // MARK: - Body

    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                contentView(viewStore)
                    .overlay(loadingView(viewStore.isLoading))
//                    .overlay(errorView(viewStore)) // TODO: Handle errors with alert...
            }
//            .onAppear { viewStore.send(.loadData) }
//            .navigationBarTitle(viewStore.props.productName)
        }
    }

    // MARK: - Content Views

    @ViewBuilder
    private func contentView(_ viewStore: ViewStore<AddReviewModalState, AddReviewModalAction>) -> some View {
        VStack {
            Text("Rating: ")
            HStack(spacing: DS.Spacing.xxSmall) {
                ForEach(0..<5) { index in
                    Button("⭐️") {
                        print("index = \(index)")
                    }
                    .font(.title)
                }
            }
        }
        Divider()
        VStack {
            Text("Your Review:")
            TextView(
                text: .constant("bla bla bla"),
                textStyle: .constant(.body)
            )
        }
    }
    
    // MARK: - Stateful Views

    @ViewBuilder
    private func loadingView(_ isVisible: Bool) -> some View {
        if isVisible {
            Spacer()
            ActivityIndicator()
            Spacer()
        }
    }
}
