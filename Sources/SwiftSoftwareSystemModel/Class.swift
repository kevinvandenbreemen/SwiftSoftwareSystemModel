public struct Class {
    public let name: String

    var interfaces: [Interface] = []

    mutating func implements(interface: Interface) {
        self.interfaces.append(interface)
    }

    public init(name: String) {
        self.name = name
    }
    
}