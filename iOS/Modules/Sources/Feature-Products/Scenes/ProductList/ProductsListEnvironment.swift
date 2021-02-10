import Foundation
import CoreUI
import RepositoryInterface
import SwiftUIViewProviderInterface

struct ProductsListEnvironment: ResolvableEnvironment {
    @Dependency var productsRepository: ProductRepositoryProtocol
}
