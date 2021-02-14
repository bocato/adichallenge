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
            forLocale: "nl_NL",
            currencyCode: currencyCode
        )
    }
}

final class DefaultCurrencyFormatter: CurrencyFormatterProtocol {
    // MARK: - Dependencies
    
    private let numberFormatter: NumberFormatter
    
    // MARK: - Initialization
    
    init(numberFormatter: NumberFormatter = .init()) {
        self.numberFormatter = numberFormatter
    }
    
    // MARK: - Public API
    
    func format(
        _ value: Double,
        forLocale localeIdentifier: String,
        currencyCode: String
    ) -> String {
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode.isEmpty ? "EUR" : currencyCode
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        guard let formattedValue = numberFormatter.string(for: value) else { return "" }
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
