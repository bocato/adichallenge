import SwiftUI
import UIKit
import NetworkingInterface
import Networking
import SwiftUIViewProviderInterface
import SwiftUIViewProvider
import CacheKit
import Feature_Products
import NetworkingInterface
import Networking
import RepositoryInterface
import Repository

struct AppContainer {
    let viewsProvider: SwiftUIViewsProviderInterface
    let httpDispatcher: HTTPRequestDispatcherProtocol
    let apiEnvironment: APIEnvironmentProvider
}
extension AppContainer {
    static let live: Self = .init(
        viewsProvider: SwiftUIViewsProvider(),
        httpDispatcher: HTTPRequestDispatcher(),
        apiEnvironment: APIEnvironment.shared
    )
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    // MARK: - Dependencies
    
    private(set) var appContainer: AppContainer!
    
    // MARK: - UIApplicationDelegate Methods
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        appContainer = .live
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
        RepositoryModule.registerDependencies(
            .init(apiEnvironment: appContainer.apiEnvironment)
        )
        appContainer.viewsProvider.register(
            dependencyFactory: { ProductRepository(httpDispatcher: appContainer.httpDispatcher) } ,
            forType: ProductRepositoryProtocol.self
        )
        appContainer.viewsProvider.register(
            dependencyFactory: { ImagesRepository() } ,
            forType: ImagesRepositoryProtocol.self
        )
        
    }
}


