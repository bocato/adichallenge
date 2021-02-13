import Foundation

protocol CurrencyFormatterProtocol {
    func format(
        _ value: Double,
        forLocale locale: String,
        currencyCode: String
    ) -> String
}

extension CurrencyFormatterProtocol {
    func format(
        _ value: Double,
        currencyCode: String
    ) -> String {
        format(
            value,
            forLocale: "en_US",
            currencyCode: currencyCode
        )
    }
}

final class DefaultCurrencyFormatter: CurrencyFormatterProtocol {
    func format(
        _ value: Double,
        forLocale localeIdentifier: String,
        currencyCode: String
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode.isEmpty ? "USD" : currencyCode
        formatter.locale = Locale(identifier: localeIdentifier)
        guard let formattedValue = formatter.string(for: value) else { return "" }
        return formattedValue
    }
}

#if DEBUG
final class CurrencyFormatterDummy: CurrencyFormatterProtocol {
    func format(
        _ value: Double,
        forLocale localeIdentifier: String,
        currencyCode: String
    ) -> String { "" }
}

final class CurrencyFormatterStub: CurrencyFormatterProtocol {
    var valueToBeReturned = ""
    func format(
        _ value: Double,
        forLocale localeIdentifier: String,
        currencyCode: String
    ) -> String { valueToBeReturned }
}
#endif
