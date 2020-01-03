/// Represents a protocol/interface in the system being parsed
public struct Interface: Type {

    public let name: String

    public var propertiesForDisplay: [PropertyForDisplay] {
        get {
            _propertiesForDisplay
        }
    }
    var _propertiesForDisplay: [PropertyForDisplay] = []
    
    public init(name: String) {
        self.name = name
    }
    

}