public class SystemModelBuilder {

    public let systemModel: SystemModel

    /// Name of a class to list of its implemented interfaces
    private var classNameToImplementedInterfaceNames: [String: [String]]

    /// Names of types mapped to fields declared before the type was encountered
    private var typeNamesToClassFields: [String: [(owningTypeName: String, fieldName: String)]]
    
    public init(systemModel model: SystemModel = SystemModel()) {
        self.systemModel = model
        self.classNameToImplementedInterfaceNames = [:]
        self.typeNamesToClassFields = [:]
    }
    
    public func addClass(clz: Class) {
        
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

        //  Handle field declarations that are for the new type
        if let missingFieldDeclarations = typeNamesToClassFields[clz.name] {
            missingFieldDeclarations.forEach{ declaration in 
                guard var existingClass = getClass(named: declaration.owningTypeName) else {
                    return
                }
                existingClass._properties.append(ClassProperty(type: clz, name: declaration.fieldName))
                updateSystemModelClass(with: existingClass)
            }
        }

        self.systemModel.addClass(clz: classToAdd)
    }

    public func addProperty(ofType className: String, to toClassName: String, named: String) {
        let existingClassOpt = systemModel.classes.first(where: {clz in 
            clz.name == className
        })
        let existingProtocolOpt = systemModel.interfaces.first(where: { ifc in 
            ifc.name == className
        })
        let existingTargetClassOpt = systemModel.classes.first(where: {clz in 
            clz.name == toClassName
        })

        guard var existingTargetClass = existingTargetClassOpt else {
            return
        }

        //  Two scenarios:
        //  1.  Class exists
        if let classForProperty = existingClassOpt {
            existingTargetClass._properties.append(ClassProperty.init(type: classForProperty, name: named))
            updateSystemModelClass(with: existingTargetClass)
        }
        //  1b. Protocol matching name exists
        else if let protocolForProperty = existingProtocolOpt {
            existingTargetClass._properties.append(ClassProperty.init(type: protocolForProperty, name: named))
            updateSystemModelClass(with: existingTargetClass)
        }

        //  2.  Class does not exist
        else {
            if typeNamesToClassFields[className] == nil {
                typeNamesToClassFields[className] = []
            }
            let fieldDec: (owningTypeName: String, fieldName: String) = (owningTypeName: toClassName, fieldName: named)
            typeNamesToClassFields[className]!.append(fieldDec)
        }
    }

    public func addInterface(interface: Interface) {
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

        //  Handle field declarations that are for the new type
        if let missingFieldDeclarations = typeNamesToClassFields[interface.name] {
            missingFieldDeclarations.forEach{ declaration in 
                guard var existingClass = getClass(named: declaration.owningTypeName) else {
                    return
                }
                existingClass._properties.append(ClassProperty(type: interface, name: declaration.fieldName))
                updateSystemModelClass(with: existingClass)
            }
        }

    }

    /// Alert this builder that the class with the given name implements the given interface
    public func addImplements(
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
        systemModel._classes.removeAll(where: {clz in 
            clz.name == updatedClass.name
        })
        systemModel.addClass(clz: updatedClass)
    }

    private func getClass(named: String) -> Class? {
        return systemModel.classes.first(where: {clz in 
            clz.name == named
        })
    }

}