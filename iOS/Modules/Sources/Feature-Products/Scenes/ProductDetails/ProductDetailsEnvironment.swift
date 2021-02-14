import Combine
import ComposableArchitecture
import CoreUI
import Foundation
import RepositoryInterface
import SwiftUIViewProviderInterface

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


// TODO: MOVE THIS

protocol EmojiConverterProtocol {
    func emojiFlag(for locale: String) -> String
}

final class DefaultEmojiConverter: EmojiConverterProtocol {
    func emojiFlag(for locale: String) -> String {
        guard let countryCode = locale.split(separator: "_").last else {
            return ""
        }
        // For future reference: https://stackoverflow.com/questions/30402435/swift-turn-a-country-code-into-a-emoji-flag-via-unicode
        return countryCode
                .unicodeScalars
                .map({ 127397 + $0.value })
                .compactMap(UnicodeScalar.init)
                .map(String.init)
                .joined()
    }
}
#if DEBUG
final class EmojiConverterDummy: EmojiConverterProtocol {
    func emojiFlag(for locale: String) -> String { "" }
}
#endif
