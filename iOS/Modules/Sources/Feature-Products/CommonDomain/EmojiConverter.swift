import Foundation

protocol EmojiConverterProtocol {
    func emojiFlag(for locale: String) -> String
    func productRatingStars(for score: Int) -> String
}

final class DefaultEmojiConverter: EmojiConverterProtocol {
    func emojiFlag(for locale: String) -> String {
        let isValidLocale = locale.range(of: #"[A-z]*-[A-z]*"#, options: .regularExpression) != nil
        guard
            isValidLocale,
            let countryCode = locale.split(separator: "-").last
        else { return "❓" }
        // For future reference: https://stackoverflow.com/questions/30402435/swift-turn-a-country-code-into-a-emoji-flag-via-unicode
        return countryCode
            .unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }

    func productRatingStars(for score: Int) -> String {
        var starEmojis = ""
        for _ in 0 ..< score {
            starEmojis += "⭐️"
        }
        return starEmojis
    }
}

#if DEBUG
final class EmojiConverterDummy: EmojiConverterProtocol {
    func emojiFlag(for _: String) -> String { "" }
    func productRatingStars(for _: Int) -> String { "" }
}

final class EmojiConverterStub: EmojiConverterProtocol {
    var emojiFlagToBeReturned = "🇧🇷"
    func emojiFlag(for _: String) -> String {
        emojiFlagToBeReturned
    }
    
    var ratingStarsToBeReturned = "⭐️⭐️⭐️⭐️"
    func productRatingStars(for _: Int) -> String {
        return ratingStarsToBeReturned
    }
}
#endif
