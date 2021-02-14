import CacheKit
import Feature_Products
import Networking
import NetworkingInterface
import Repository
import RepositoryInterface
import SwiftUI
import SwiftUIViewProvider
import SwiftUIViewProviderInterface
import UIKit

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
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
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
            dependencyFactory: { ProductsRepository(httpDispatcher: appContainer.httpDispatcher) },
            forType: ProductsRepositoryProtocol.self
        )
        appContainer.viewsProvider.register(
            dependencyFactory: { ImagesRepository() },
            forType: ImagesRepositoryProtocol.self
        )
    }
}
