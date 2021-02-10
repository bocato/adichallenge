//import Foundation
//import NetworkingInterface
//
//extension URLRequestProtocol {
//    var environment: APIEnvironmentProvider {
//        get {
//            let value = environmentProviderInstance ?? APIEnvironment.shared
//            return value
//        }
//        set { environmentProviderInstance = newValue }
//    }
//
//    private var environmentProviderInstance: APIEnvironmentProvider? {
//        get {
//            let objcAssociatedObject = objc_getAssociatedObject(self, &AssociatedKeys.environmentProviderReference)
//            return objcAssociatedObject as? APIEnvironmentProvider
//        }
//        set {
//            objc_setAssociatedObject(
//                self,
//                &AssociatedKeys.environmentProviderReference,
//                newValue,
//                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
//            )
//        }
//    }
//}
//private enum AssociatedKeys {
//    static var environmentProviderReference = "environmentProviderReference"
//}
