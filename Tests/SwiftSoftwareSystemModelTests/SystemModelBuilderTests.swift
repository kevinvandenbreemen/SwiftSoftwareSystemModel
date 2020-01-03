import XCTest
@testable import SwiftSoftwareSystemModel

class SystemModelBuilderTests: XCTestCase {

    func testDetectsInterfaceImplementation() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")

        builder.addInterface(interface: ifc)
        builder.addClass(clz: clz)

        builder.addImplements(type: "Implementor", implements: "Interface")

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }

    func testRegisteresInterfaceImplementationBeforeInterfaceEncountered() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")
        
        builder.addClass(clz: clz)
        builder.addImplements(type: "Implementor", implements: "Interface")
        builder.addInterface(interface: ifc)

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }

    func testRegistersInterfaceImplementationBeforeClassOrInterfaceEncountered() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")
        
        builder.addImplements(type: "Implementor", implements: "Interface")
        builder.addInterface(interface: ifc)
        builder.addClass(clz: clz)

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }

    func testRegistersInterfaceImplementationBeforeClassOrInterfaceEncounteredClassThenInterfaceAdded() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Interface")
        let clz = Class.init(name: "Implementor")
        
        builder.addImplements(type: "Implementor", implements: "Interface")
        builder.addClass(clz: clz)
        builder.addInterface(interface: ifc)

        let firstClass = builder.systemModel.classes[0]
        
        let interfaces = firstClass.interfaces
        guard interfaces.count == 1 else {
            XCTFail("Type \(firstClass.name) should have a single implemented interface")
            return
        }

        XCTAssertEqual(interfaces[0].name, ifc.name)
    }

    func testAddsMemberToClass() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        let owned = Class.init(name: "Owned")
        
        builder.addClass(clz: clz)
        builder.addClass(clz: owned)
        builder.addProperty(ofType: owned.name, to: clz.name, named: "ownedMember")

        let firstClass = builder.systemModel.classes.first(where: {c in c.name == clz.name})!
        XCTAssertFalse(firstClass.properties.isEmpty, "Members were not added to the class \(firstClass)")

        let targetClass = firstClass.properties[0].type
        XCTAssertEqual(targetClass.name, owned.name)
    }

    func testAddsMemberToClassBeforeMemberTypeEncountered() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        let owned = Class.init(name: "Owned")
        
        builder.addClass(clz: clz)
        builder.addProperty(ofType: "Owned", to: clz.name, named: "ownedMember")
        builder.addClass(clz: owned)

        let firstClass = builder.systemModel.classes.first(where: {c in c.name == clz.name})!
        XCTAssertFalse(firstClass.properties.isEmpty, "Members were not added to the class \(firstClass)")

        let targetClass = firstClass.properties[0].type
        XCTAssertEqual(targetClass.name, owned.name)
    }

    func testAddsInterfaceMemberToClass() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        let owned = Interface.init(name: "Owned")
        
        builder.addClass(clz: clz)
        builder.addInterface(interface: owned)
        builder.addProperty(ofType: owned.name, to: clz.name, named: "ownedMember")

        let firstClass = builder.systemModel.classes.first(where: {c in c.name == clz.name})!
        XCTAssertFalse(firstClass.properties.isEmpty, "Members were not added to the class \(firstClass)")

        let targetClass = firstClass.properties[0].type
        XCTAssertEqual(targetClass.name, owned.name)
    }

    func testAddsInterfaceMemberToClassBeforeInterfaceEncountered() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        let owned = Interface.init(name: "Owned")
        
        builder.addClass(clz: clz)
        builder.addProperty(ofType: "Owned", to: clz.name, named: "ownedMember")
        builder.addInterface(interface: owned)

        let firstClass = builder.systemModel.classes.first(where: {c in c.name == clz.name})!
        XCTAssertFalse(firstClass.properties.isEmpty, "Members were not added to the class \(firstClass)")

        let targetClass = firstClass.properties[0].type
        XCTAssertEqual(targetClass.name, owned.name)
    }

    func testAddsFieldForDocumentation() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        
        builder.addClass(clz: clz)

        builder.addProperty(ofType: "NoSuchClass", to: "Owner", named: "noSuchClass")

        let built = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "Owner"
        })!

        XCTAssertEqual(1, built.propertiesForDisplay.count)
        let property = built.propertiesForDisplay[0]
        XCTAssertEqual("noSuchClass", property.name)
        XCTAssertEqual(.single, property.multiplicity)
        XCTAssertEqual("NoSuchClass", property.type)
    }

    func testAddsFieldForDocumentationForProtocol() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Owner")
        
        builder.addInterface(interface: ifc)

        builder.addProperty(ofType: "NoSuchClass", to: "Owner", named: "noSuchClass")

        let built = builder.systemModel.interfaces.first(where: { clz in 
            return clz.name == "Owner"
        })!

        XCTAssertEqual(1, built.propertiesForDisplay.count)
        let property = built.propertiesForDisplay[0]
        XCTAssertEqual("noSuchClass", property.name)
        XCTAssertEqual(.single, property.multiplicity)
        XCTAssertEqual("NoSuchClass", property.type)
    }

    func testAllowsProvidingAdditionalDetailsOnNewField() {
        let builder = SystemModelBuilder()
        
        let clz = Class.init(name: "Owner")
        
        builder.addClass(clz: clz)

        builder.addProperty(ofType: "NoSuchClass", to: "Owner", named: "noSuchClass", additionalDetails: PropertyDetails(optional: true))

        let built = builder.systemModel.classes.first(where: { clz in 
            return clz.name == "Owner"
        })!

        XCTAssertEqual(1, built.propertiesForDisplay.count)
        let property = built.propertiesForDisplay[0]
        
        guard let additionalDetails = property.additionalDetails else {
            XCTFail("Additional details not found")
            return
        }

        XCTAssertTrue(additionalDetails.optional)
    }

    func testAllowsProvidingAdditionalDetailsOnNewFieldForProtocol() {
        let builder = SystemModelBuilder()
        
        let ifc = Interface.init(name: "Owner")
        
        builder.addInterface(interface: ifc)

        builder.addProperty(ofType: "NoSuchClass", to: "Owner", named: "noSuchClass", additionalDetails: PropertyDetails(optional: true))

        let built = builder.systemModel.interfaces.first(where: { ifc in 
            return ifc.name == "Owner"
        })!

        XCTAssertEqual(1, built.propertiesForDisplay.count)
        let property = built.propertiesForDisplay[0]
        
        guard let additionalDetails = property.additionalDetails else {
            XCTFail("Additional details not found")
            return
        }

        XCTAssertTrue(additionalDetails.optional)
    }

    static var allTests = [
        ("Adds existing interface to a class", testDetectsInterfaceImplementation),
        ("Adds interface to a class even when interface not yet encountered at time of implements decl", testRegisteresInterfaceImplementationBeforeInterfaceEncountered),
        ("Adds interface to a class even when neither the class nor the interface have been encountered at time of implements decl", testRegistersInterfaceImplementationBeforeClassOrInterfaceEncountered),
        ("Adds interface to a class when class then interface added after initial implementation", testRegistersInterfaceImplementationBeforeClassOrInterfaceEncounteredClassThenInterfaceAdded),
        ("Adds a member to a class", testAddsMemberToClass),
        ("Can add members to a class even when those members are of unknown types", testAddsMemberToClassBeforeMemberTypeEncountered),
        ("Can detect a member that is an interface", testAddsInterfaceMemberToClass),
        ("Can detect an interface member before that interface encountered", testAddsInterfaceMemberToClassBeforeInterfaceEncountered),
        ("Can add a field for documentation", testAddsFieldForDocumentation),
        ("Can add a field for documentation (protocol)", testAddsFieldForDocumentationForProtocol),
        ("Allows providing additional details for new field", testAllowsProvidingAdditionalDetailsOnNewField),
        ("Allows providing additional details for new field (protocol)", testAllowsProvidingAdditionalDetailsOnNewFieldForProtocol),
    ]

}