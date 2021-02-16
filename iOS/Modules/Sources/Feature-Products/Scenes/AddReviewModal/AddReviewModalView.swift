import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import FoundationKit
import SwiftUI

struct AddReviewModalView: View {
    // MARK: - Dependencies

    private let store: Store<AddReviewModalState, AddReviewModalAction>

    // MARK: - Initialization

    init(store: Store<AddReviewModalState, AddReviewModalAction>) {
        self.store = store
    }

    // MARK: - Body

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(L10n.AddReviewModal.title)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .padding(.top, DS.Spacing.base)

                Divider()
                ratingContainer(viewStore)
                Divider()
                reviewTextContainer(viewStore)
                footerButtonsView(viewStore)
                    .frame(height: DS.LayoutSize.large.height)
            }
            .alert(
                store.scope(state: { $0.errorAlert }),
                dismiss: .errorAlertDismissed
            )
        }
    }

    // MARK: - Content Views

    @ViewBuilder
    private func ratingContainer(_ viewStore: ViewStore<AddReviewModalState, AddReviewModalAction>) -> some View {
        VStack {
            Text(L10n.AddReviewModal.RatingContainer.title)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.bottom, DS.Spacing.xxSmall)

            HStack(spacing: DS.Spacing.xxSmall) {
                ForEach(0 ..< 5) { index in
                    Button("⭐️") {
                        viewStore.send(.updateReviewRating(index))
                    }
                    .frame(width: DS.LayoutSize.large.width, height: DS.LayoutSize.large.height)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: DS.LayoutSize.large.height,
                            style: .continuous
                        )
                        .stroke(Color.secondary)
                        .opacity(viewStore.rating == index ? 1 : 0)
                    )
                    .opacity(viewStore.rating == index ? 1 : 0.35)
                    .font(.title)
                }
            }
        }
    }

    @ViewBuilder
    private func reviewTextContainer(_ viewStore: ViewStore<AddReviewModalState, AddReviewModalAction>) -> some View {
        VStack {
            Text(L10n.AddReviewModal.ReviewContainer.title)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.top, DS.Spacing.xxSmall)

            TextView(
                text: viewStore.binding(
                    get: { $0.reviewText },
                    send: { .updateReviewText($0) }
                ),
                textStyle: .constant(.body)
            )
            .padding(.all, DS.Spacing.xxSmall)
            .background(
                Rectangle()
                    .stroke(Color.secondary)
                    .padding(.all, DS.Spacing.xxSmall)
            )
        }
    }

    @ViewBuilder
    private func footerButtonsView(_ viewStore: ViewStore<AddReviewModalState, AddReviewModalAction>) -> some View {
        Group {
            HStack {
                Button(L10n.AddReviewModal.BottomContainer.Button.cancel) {
                    viewStore.send(.dismissItSelf)
                }
                .buttonStyle(
                    RoundedButtonStyle(
                        foregroundColor: .secondary,
                        borderColor: .secondary
                    )
                )

                Button(L10n.AddReviewModal.BottomContainer.Button.save) {
                    viewStore.send(.saveReview)
                }
                .buttonStyle(RoundedButtonStyle())
            }
            .opacity(viewStore.isLoading ? 0 : 1)
            .overlay(
                RoundedRectangle(
                    cornerRadius: DS.LayoutSize.large.height,
                    style: .continuous
                )
                .stroke(Color.secondary)
                .frame(height: DS.LayoutSize.large.height)
                .opacity(viewStore.isLoading ? 1 : 0)
                .padding()
            )
            .overlay(loadingView(viewStore.isLoading))
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
