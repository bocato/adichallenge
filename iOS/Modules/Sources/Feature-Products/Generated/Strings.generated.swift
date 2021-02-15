// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
// Custom template

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum ProductDetails {
    internal enum EmptyView {
      /// We could not find the content for this page, try again soon...
      internal static var subtitle: String {
        L10n.tr("Localizable", "productDetails.emptyView.subtitle")
      }
      /// Oh no!
      internal static var title: String {
        L10n.tr("Localizable", "productDetails.emptyView.title")
      }
    }
    internal enum ProductReviewRow {
      /// Locale:
      internal static var locale: String {
        L10n.tr("Localizable", "productDetails.productReviewRow.locale")
      }
      /// Rating:
      internal static var rating: String {
        L10n.tr("Localizable", "productDetails.productReviewRow.rating")
      }
    }
  }

  internal enum ProductList {
    /// Products List
    internal static var navigationBarTitle: String {
      L10n.tr("Localizable", "productList.navigationBarTitle")
    }
    internal enum EmptyView {
      /// We could not find the content for this page, try another Search Term...
      internal static var subtitle: String {
        L10n.tr("Localizable", "productList.emptyView.subtitle")
      }
      /// Oh no!
      internal static var title: String {
        L10n.tr("Localizable", "productList.emptyView.title")
      }
    }
    internal enum FilteringView {
      /// Could not find anything related to the input.
      internal static var emptyResults: String {
        L10n.tr("Localizable", "productList.filteringView.emptyResults")
      }
      /// Filtering...
      internal static var text: String {
        L10n.tr("Localizable", "productList.filteringView.text")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = Bundle.module.localizedString(forKey: key, value: "", table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

