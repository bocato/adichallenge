import SwiftUI
import UIKit
import NetworkingInterface
import Networking
import SwiftUIViewProviderInterface
import SwiftUIViewProvider
import Feature_Products
import RepositoryInterface
import Repository

struct AppContainer {
    let viewsProvider: SwiftUIViewsProviderInterface
    let httpDispatcher: HTTPRequestDispatcherProtocol
}
extension AppContainer {
    static let live: Self = .init(
        viewsProvider: SwiftUIViewsProvider(),
        httpDispatcher: HTTPRequestDispatcher()
    )
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    // MARK: - Dependencies
    
    let appContainer: AppContainer = .live
    
    // MARK: - UIApplicationDelegate Methods
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        registerRouteHandlers(
            for: appContainer.viewsProvider
        )
        registerDependencies(
            using: appContainer
        )
        return true
    }
    
    // MARK: - Dependency Registration
    
    private func registerRouteHandlers(for viewProvider: FeatureDependenciesRegistering) {
        viewProvider.register(routesHandler: ProductsFeatureRoutesHandler())
    }
    
    private func registerDependencies(using appContainer: AppContainer) {
        appContainer.viewsProvider.register(
            dependencyFactory: { ProductRepository(httpDispatcher: appContainer.httpDispatcher) } ,
            forType: ProductRepositoryProtocol.self
        )
    }
}


