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
    internal enum EmptyContentView {
        internal enum Button {
            /// Refresh
            internal static var text: String {
                L10n.tr("Localizable", "emptyContentView.button.text")
            }
        }
    }

    internal enum ErrorView {
        /// Something is wrong, try again later.
        internal static var subtitle: String {
            L10n.tr("Localizable", "errorView.subtitle")
        }

        /// Ops!
        internal static var title: String {
            L10n.tr("Localizable", "errorView.title")
        }

        internal enum Button {
            /// Retry
            internal static var text: String {
                L10n.tr("Localizable", "errorView.button.text")
            }
        }
    }

    internal enum SearchBar {
        /// Cancel
        internal static var cancelText: String {
            L10n.tr("Localizable", "searchBar.cancelText")
        }

        /// Search
        internal static var placeholder: String {
            L10n.tr("Localizable", "searchBar.placeholder")
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
