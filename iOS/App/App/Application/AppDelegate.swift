import CacheKit
import DependencyManager
import DependencyManagerInterface
import Feature_Products
import Networking
import NetworkingInterface
import Repository
import RepositoryInterface
import SwiftUI
import UIKit

struct AppContainer {
    let dependenciesContainer: DependenciesContainerInterface
    let httpDispatcher: HTTPRequestDispatcherProtocol
    let apiEnvironment: APIEnvironmentProvider
}

extension AppContainer {
    static let live: Self = .init(
        dependenciesContainer: DependenciesContainer(),
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
        registerDependencies(
            using: appContainer
        )
        initializeModules(
            with: appContainer
        )
        return true
    }

    // MARK: - Dependency Registration

    private func registerDependencies(using appContainer: AppContainer) {
        appContainer.dependenciesContainer.register(
            factory: { ProductsRepository(httpDispatcher: appContainer.httpDispatcher) },
            forMetaType: ProductsRepositoryProtocol.self
        )
        appContainer.dependenciesContainer.register(
            factory: { ReviewsRepository(httpDispatcher: appContainer.httpDispatcher) },
            forMetaType: ReviewsRepositoryProtocol.self
        )
        appContainer.dependenciesContainer.register(
            factory: { ImagesRepository() },
            forMetaType: ImagesRepositoryProtocol.self
        )
    }

    private func initializeModules(with appContainer: AppContainer) {
        RepositoryModule.registerDependencies(
            .init(apiEnvironment: appContainer.apiEnvironment)
        )
        ProductsFeature.initialize(
            withContainer: appContainer.dependenciesContainer
        )
    }
}
