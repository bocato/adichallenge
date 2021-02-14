import Combine
import ComposableArchitecture
import CoreUI
import Foundation
import RepositoryInterface
import SwiftUIViewProviderInterface

struct ProductsListEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductsRepositoryProtocol
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
#if DEBUG
extension ProductsListEnvironment {
    static func fixture(
        productsRepository: ProductsRepositoryProtocol = ProductsRepositoryDummy(),
        imagesRepository: ImagesRepositoryProtocol =  ImagesRepositoryDummy(),
        currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()
    ) -> Self {
        var instance: Self = .init(
            currencyFormatter: currencyFormatter,
            mainQueue: mainQueue
        )
        instance._productsRepository = .resolvedValue(productsRepository)
        instance._imagesRepository = .resolvedValue(imagesRepository)
        return instance
    }
}
#endif
