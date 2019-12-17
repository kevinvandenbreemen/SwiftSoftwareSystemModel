public class SystemModel {

    var classes: [Class]
    var interfaces: [Interface]
    
    public init() {
        self.classes = []
        self.interfaces = []
    }
    
    func addClass(clz: Class) {
        self.classes.append(clz)
    }

    func addInterface(interface: Interface) {
        self.interfaces.append(interface)
    }

}