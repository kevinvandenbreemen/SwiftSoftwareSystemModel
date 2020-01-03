/// Allows you to specify additional information about a property on a type
public struct PropertyDetails {

    public let optional: Bool

    
    init(optional: Bool = false) {
        self.optional = optional
    }
    

}