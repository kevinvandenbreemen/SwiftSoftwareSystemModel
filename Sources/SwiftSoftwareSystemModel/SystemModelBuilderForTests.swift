public class SystemModelBuilderForTests: SystemModelBuilder {

    
    public init() {
        super.init()
    }
    

    public func addClass(named: String) {
        super.addClass(clz: Class(name: named))
    }

}