public protocol AnalyticsType {
    associatedtype Event: EventType
    func register(provider: ProviderType)
    func log(_ event: Event)
}

public protocol ProviderType {
    func log(_ eventName: String, parameters: [String: Any]?)
    func identify(parameters: [String: Any])
    func startSession()
}

public protocol EventType {
    func name(for provider: ProviderType) -> String?
    func parameters(for provider: ProviderType) -> [String: Any]?
}

open class Analytics<Event: EventType>: AnalyticsType {
    private(set) open var providers: [ProviderType] = []

    public init() {
        // I'm Analytics 👋
    }

    open func register(provider: ProviderType) {
        self.providers.append(provider)
    }

    open func log(_ event: Event) {
        for provider in self.providers {
            guard let eventName = event.name(for: provider) else { continue }
            let parameters = event.parameters(for: provider)
            provider.log(eventName, parameters: parameters)
        }
    }

    open func identify(parameters: [String: Any]) {
        for provider in self.providers {
            provider.identify(parameters: parameters)
        }
    }

    open func startSession() {
        for provider in self.providers {
            provider.startSession()
        }
    }
}
