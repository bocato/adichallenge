import Foundation
import NetworkingInterface

extension URLRequestProtocol {
    var apiEnvironment: APIEnvironmentProvider {
        get {
            let value = apiEnvironmentInstance ?? RepositoryModule.dependencies().apiEnvironment
            return value
        }
        set { apiEnvironmentInstance = newValue }
    }

    private var apiEnvironmentInstance: APIEnvironmentProvider? {
        get {
            let objcAssociatedObject = objc_getAssociatedObject(self, &AssociatedKeys.apiEnvironmentInstanceKey)
            return objcAssociatedObject as? APIEnvironmentProvider
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.apiEnvironmentInstanceKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

private enum AssociatedKeys {
    static var apiEnvironmentInstanceKey = "apiEnvironmentInstanceKey"
}
