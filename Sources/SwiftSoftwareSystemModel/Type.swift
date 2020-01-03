/// Base protocol for something that is a type (protocol/class/struct)
public protocol Type {

    var name: String { get }
    var propertiesForDisplay: [PropertyForDisplay] { get }

}