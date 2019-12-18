public class SystemModel {

    var _classes: [Class]
    var _interfaces: [Interface]

    public var classes: [Class] {
        get {
            return _classes
        }
    }

    public var interfaces: [Interface] {
        get {
            return _interfaces
        }
    }
    
    public init() {
        self._classes = []
        self._interfaces = []
    }
    
    func addClass(clz: Class) {
        self._classes.append(clz)
    }

    func addInterface(interface: Interface) {
        self._interfaces.append(interface)
    }

}