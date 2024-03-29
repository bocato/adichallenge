//
//  File.swift
//
//
//  Created by Eduardo Sanches Bocato on 15/02/21.
//

@testable import Feature_Products
import Foundation
import XCTest

final class DefaultEmojiConverterTests: XCTestCase {
    // MARK: - Tests

    func test_emojiFlag_whenLocaleIsInvalid_itShouldReturnQuestionMarkEmoji() {
        // Given
        let sut = DefaultEmojiConverter()
        let invalidLocale = "not a valid locale"
        // When
        let flagEmoji = sut.emojiFlag(for: invalidLocale)
        // Then
        XCTAssertEqual(flagEmoji, "❓")
    }

    func test_emojiFlag_whenLocaleIsValid_itShouldReturnFlagEmoji() {
        // Given
        let sut = DefaultEmojiConverter()
        let validLocale = "pt-BR"
        // When
        let flagEmoji = sut.emojiFlag(for: validLocale)
        // Then
        XCTAssertNotEqual(flagEmoji, "❓")
    }

    func test_productRatingStars_shouldReturnTheSameAmountOfStarsRatingParameter() {
        // Given
        let sut = DefaultEmojiConverter()
        let starsCount = 5
        // When
        let starEmojis = sut.productRatingStars(for: 5)
        // Then
        XCTAssertEqual(starEmojis.count, starsCount)
    }
}
