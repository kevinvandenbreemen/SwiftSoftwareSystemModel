public class SystemModelBuilder {

    public let systemModel: SystemModel

    /// Name of a class to list of its implemented interfaces
    private var classNameToImplementedInterfaceNames: [String: [String]]
    
    public init(systemModel model: SystemModel = SystemModel()) {
        self.systemModel = model
        self.classNameToImplementedInterfaceNames = [:]
    }
    
    func addClass(clz: Class) {
        
        var classToAdd = clz
        if let interfacesImplementedByClassName = classNameToImplementedInterfaceNames[clz.name] {
            for interfaceName in interfacesImplementedByClassName {
                if let existingInterface = systemModel.interfaces.first(where: {interface in 
                    interface.name == interfaceName
                }) {
                    classToAdd.implements(interface: existingInterface)
                }
            }
        }

        self.systemModel.addClass(clz: classToAdd)
    }

    func addInterface(interface: Interface) {
        self.systemModel.addInterface(interface: interface)

        for (className, interfaces) in classNameToImplementedInterfaceNames {
            if let _ = interfaces.first(where: {ifc in 
                ifc == interface.name
            }), var alreadyExistingClass = systemModel.classes.first(where: {clz in 
                clz.name == className
            }) {
                alreadyExistingClass.implements(interface: interface)
                updateSystemModelClass(with: alreadyExistingClass)
            }
        }

    }

    /// Alert this builder that the class with the given name implements the given interface
    func addImplements(
        type className: String,     //  Note that I use a string here, not a Class as we want to be able to handle extension declarations in separate files
        implements interfaceName: String) {

        let existingClassOpt = systemModel.classes.first(where: {clz in 
            clz.name == className
        })
        let existingInterfaceOpt = systemModel.interfaces.first(where: {ifc in
            ifc.name == interfaceName
        })

        //  Two scenarios:
        //  1:  The class is already registered
        if var existingClass = existingClassOpt {

            //  Two sub-scenarios: 
            //  1:  Interface already registered
            if let existingInterface = existingInterfaceOpt {
                
                existingClass.implements(interface: existingInterface)
                updateSystemModelClass(with: existingClass)

            }

            //  2:  Interface not yet registered
            else {
                if classNameToImplementedInterfaceNames[existingClass.name] == nil {
                    classNameToImplementedInterfaceNames[existingClass.name] = []
                }
                classNameToImplementedInterfaceNames[existingClass.name]!.append(interfaceName)
            }

        }

        //  2:  The class is not yet registered
        else {

            //  Two sub-scenarios:
            //  1:  The interface is not yet registered
            if classNameToImplementedInterfaceNames[className] == nil {
                classNameToImplementedInterfaceNames[className] = []
            }
            classNameToImplementedInterfaceNames[className]!.append(interfaceName)
        }

    }

    private func updateSystemModelClass(with updatedClass: Class) {
        systemModel.classes.removeAll(where: {clz in 
            clz.name == updatedClass.name
        })
        systemModel.addClass(clz: updatedClass)
    }

}