public struct Class {
    public let name: String

    public var interfaces: [Interface] {
        get {
            return _interfaces
        }
    }
    var _interfaces: [Interface] = []

    mutating func implements(interface: Interface) {
        self._interfaces.append(interface)
    }

    public init(name: String) {
        self.name = name
    }
    
}