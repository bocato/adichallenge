import Combine
import ComposableArchitecture
import CoreUI
import Foundation
import RepositoryInterface
import SwiftUIViewProviderInterface

struct ProductsListEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductRepositoryProtocol
    @Dependency var imagesRepository: ImagesRepositoryProtocol
    var currencyFormatter: CurrencyFormatterProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>

    init(
        currencyFormatter: CurrencyFormatterProtocol = DefaultCurrencyFormatter(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.currencyFormatter = currencyFormatter
        self.mainQueue = mainQueue
    }
}
