import Foundation
import NetworkingInterface

extension URLRequestProtocol {
    var baseURL: URL {
        get {
            let value = storedBaseURL ?? RepositoryModule.dependencies().apiEnvironment.baseURL
            return value
        }
        set { storedBaseURL = newValue }
    }

    private var storedBaseURL: URL? {
        get {
            let objcAssociatedObject = objc_getAssociatedObject(self, &AssociatedKeys.storedBaseURLKey)
            return objcAssociatedObject as? URL
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.storedBaseURLKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

private enum AssociatedKeys {
    static var storedBaseURLKey = "baseURLKey"
}
