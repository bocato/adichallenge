import Feature_Products
import SwiftUI

@main
struct AppMain: App {
    // swiftlint:disable weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ProductsListView()
        }
    }
}
