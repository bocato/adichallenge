import Foundation
import CoreUI
import Combine
import RepositoryInterface
import SwiftUIViewProviderInterface
import ComposableArchitecture

struct ProductsListEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductRepositoryProtocol
    @Dependency var imagesRepository: ImagesRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init(mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()) {
        self.mainQueue = mainQueue
    }
}
