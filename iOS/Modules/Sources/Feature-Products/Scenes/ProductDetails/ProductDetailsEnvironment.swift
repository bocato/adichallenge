import Combine
import ComposableArchitecture
import CoreUI
import Foundation
import RepositoryInterface
import DependencyManagerInterface

struct ProductDetailsEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductsRepositoryProtocol
    @Dependency var imagesRepository: ImagesRepositoryProtocol
    var currencyFormatter: CurrencyFormatterProtocol
    var emojiConverter: EmojiConverterProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>

    init(
        currencyFormatter: CurrencyFormatterProtocol = DefaultCurrencyFormatter(),
        emojiConverter: EmojiConverterProtocol = DefaultEmojiConverter(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.currencyFormatter = currencyFormatter
        self.emojiConverter = emojiConverter
        self.mainQueue = mainQueue
    }
}
#if DEBUG
extension ProductDetailsEnvironment {
    static func fixture(
        productsRepository: ProductsRepositoryProtocol = ProductsRepositoryDummy(),
        imagesRepository: ImagesRepositoryProtocol =  ImagesRepositoryDummy(),
        currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy(),
        emojiConverter: EmojiConverterProtocol = EmojiConverterDummy(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()
    ) -> Self {
        var instance: Self = .init(
            currencyFormatter: currencyFormatter,
            emojiConverter: emojiConverter,
            mainQueue: mainQueue
        )
        instance._productsRepository = .resolvedValue(productsRepository)
        instance._imagesRepository = .resolvedValue(imagesRepository)
        return instance
    }
}
#endif
