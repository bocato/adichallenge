import Foundation

extension Error {
    private var networkErrors: [Int] {
        return [
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorDNSLookupFailed,
            NSURLErrorResourceUnavailable,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorBadServerResponse,
            NSURLErrorInternationalRoamingOff,
            NSURLErrorCallIsActive
        ]
    }
    
    var isNetworkConnectionError: Bool {
        let nsError = self as NSError
        return nsError.domain == NSURLErrorDomain &&
            networkErrors.contains(nsError.code)
    }
    
}
