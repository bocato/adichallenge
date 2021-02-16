
# General Information

## Environment setup
Since this project uses [SwiftLint](https://github.com/realm/SwiftLint), [SwiftFormat](https://github.com/nicklockwood/SwiftFormat), [Fastlane](https://fastlane.tools) and [Swiftgen](https://github.com/SwiftGen/SwiftGen), you need to install those dependencies on your machine for it to build. To do that, run `make environment` from the project's root folder.

# Makefile commands
- `make clean`: cleans iOS derived data.
- `make environment`: Installs the project dependencies
- `make update_strings`: Updates the SwiftGen generated code for the Localizable.strings files
- `make start_server`: starts the local server
- `make run_tests`: runs the test suite with XCov and opens the html report
- `make code_beautify`: runs SwiftFormat and SwiftLint to keep the code in shape based on it's linting and formatting definitions
