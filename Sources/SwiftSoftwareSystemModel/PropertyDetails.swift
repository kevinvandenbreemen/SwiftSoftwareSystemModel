/// Allows you to specify additional information about a property on a type
public struct PropertyDetails {

    public let optional: Bool
    public let tuple: Bool
    
    public init(
        optional: Bool = false,
        tuple: Bool = false
    ) {
        self.optional = optional
        self.tuple = tuple
    }
    

}