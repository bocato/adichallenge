import Foundation
import CoreUI
import Combine
import RepositoryInterface
import SwiftUIViewProviderInterface
import ComposableArchitecture

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
