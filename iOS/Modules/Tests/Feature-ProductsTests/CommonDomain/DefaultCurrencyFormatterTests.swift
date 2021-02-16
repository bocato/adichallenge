@testable import Feature_Products
import XCTest

final class DefaultCurrencyFormatterTests: XCTestCase {
    // MARK: - Tests

    func test_format_whenLocaleIsNotProvided_itShouldBeSetTo() {
        // Given
        let sut: NoLocaleProvidedSpy = .init()
        // When
        _ = sut.format(1.23, currencyCode: "EUR")
        // Then
        XCTAssertEqual(sut.localeIdentifierPassed, "nl_NL")
    }

    func test_format_whenNumberFormatterReturnsNil_itShouldReturnAnEmptyString() {
        // Given
        let fakeNumberFormatter: FakeNumberFormatter = .init()
        let sut: DefaultCurrencyFormatter = .init(numberFormatter: fakeNumberFormatter)
        // When
        let formattedValue = sut.format(1.23, currencyCode: "")
        // Then
        XCTAssertTrue(formattedValue.isEmpty)
    }

    func test_format_whenCurrencyCodeIsEmpty_itShouldAssumeNL_And_EUR() {
        // Given
        let sut: DefaultCurrencyFormatter = .init()
        // When
        let formattedValue = sut.format(1.23, currencyCode: "")
        // Then
        XCTAssertEqual(formattedValue, "€ 1,23")
    }

    func test_format_shouldFormatValuesCorrectly() {
        // Given
        let sut: DefaultCurrencyFormatter = .init()
        // When
        let formattedValue = sut.format(1.23, forLocale: "pt_BR", currencyCode: "BRL")
        // Then
        XCTAssertEqual(formattedValue, "R$ 1,23")
    }
}

// MARK: - Testing Helpers

private final class NoLocaleProvidedSpy: CurrencyFormatterProtocol {
    private(set) var localeIdentifierPassed: String?
    func format(
        _: Double,
        forLocale localeIdentifier: String,
        currencyCode _: String
    ) -> String {
        localeIdentifierPassed = localeIdentifier
        return ""
    }
}

final class FakeNumberFormatter: NumberFormatter {
    override func string(for _: Any?) -> String? {
        return nil
    }
}
