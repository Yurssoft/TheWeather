import Combine
import CoreLocation

public extension LocationClient {
    typealias DelegatePublisher = AnyPublisher<DelegateEvent, Never>
}

public extension LocationClient {
    enum DelegateEvent {
        case didChangeAuthorization(CLAuthorizationStatus)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
    }
}

public struct LocationClient {
    public var authorizationStatus: () -> CLAuthorizationStatus
    public var requestWhenInUseAuthorization: () -> Void
    public var requestLocation: () -> Void
    public var delegate: DelegatePublisher
    
    public init(
        authorizationStatus: @escaping () -> CLAuthorizationStatus,
        requestWhenInUseAuthorization: @escaping () -> Void,
        requestLocation: @escaping () -> Void,
        delegate: AnyPublisher<DelegateEvent, Never>
    ) {
        self.authorizationStatus = authorizationStatus
        self.requestWhenInUseAuthorization = requestWhenInUseAuthorization
        self.requestLocation = requestLocation
        self.delegate = delegate
    }
}
