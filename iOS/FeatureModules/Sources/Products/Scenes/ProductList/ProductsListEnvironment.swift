import Foundation
import CoreUI
import RepositoryInterface
import SwiftUIViewProviderInterface

struct ProductsListEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductRepositoryProtocol
    
    init(productsRepository: ProductRepositoryProtocol) {
        self._productsRepository = .resolvedValue(productsRepository)
    }
}
