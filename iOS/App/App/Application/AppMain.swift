import Feature_Products
import SwiftUI
import SwiftUIViewProvider
import SwiftUIViewProviderInterface

@main
struct AppMain: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            rootView
        }
    }

    private var rootView: some View {
        appDelegate
            .appContainer
            .viewsProvider
            .rootView(for: ProductsFeature.self)
            .eraseToAnyView()
    }
}
