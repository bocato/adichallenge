import Combine
import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import Foundation
import RepositoryInterface

struct ProductDetailsEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductsRepositoryProtocol
    @Dependency var imagesRepository: ImagesRepositoryProtocol
    var currencyFormatter: CurrencyFormatterProtocol
    var emojiConverter: EmojiConverterProtocol
    var generateUUIDString: () -> String
    var mainQueue: AnySchedulerOf<DispatchQueue>

    init(
        currencyFormatter: CurrencyFormatterProtocol = DefaultCurrencyFormatter(),
        emojiConverter: EmojiConverterProtocol = DefaultEmojiConverter(),
        generateUUIDString: @escaping () -> String = { UUID().uuidString },
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.currencyFormatter = currencyFormatter
        self.emojiConverter = emojiConverter
        self.generateUUIDString = generateUUIDString
        self.mainQueue = mainQueue
    }
}

#if DEBUG
    extension ProductDetailsEnvironment {
        static func fixture(
            productsRepository: ProductsRepositoryProtocol = ProductsRepositoryDummy(),
            imagesRepository: ImagesRepositoryProtocol = ImagesRepositoryDummy(),
            currencyFormatter: CurrencyFormatterProtocol = CurrencyFormatterDummy(),
            emojiConverter: EmojiConverterProtocol = EmojiConverterDummy(),
            generateUUIDString: @escaping () -> String = { "id" },
            mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()
        ) -> Self {
            var instance: Self = .init(
                currencyFormatter: currencyFormatter,
                emojiConverter: emojiConverter,
                generateUUIDString: generateUUIDString,
                mainQueue: mainQueue
            )
            instance._productsRepository = .resolvedValue(productsRepository)
            instance._imagesRepository = .resolvedValue(imagesRepository)
            return instance
        }
    }
#endif
