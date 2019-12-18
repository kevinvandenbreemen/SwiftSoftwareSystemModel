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
    }


    static var allTests = [
        ("Adds existing interface to a class", testDetectsInterfaceImplementation),
        ("Adds interface to a class even when interface not yet encountered at time of implements decl", testRegisteresInterfaceImplementationBeforeInterfaceEncountered),
        ("Adds interface to a class even when neither the class nor the interface have been encountered at time of implements decl", testRegistersInterfaceImplementationBeforeClassOrInterfaceEncountered),
        ("Adds interface to a class when class then interface added after initial implementation", testRegistersInterfaceImplementationBeforeClassOrInterfaceEncounteredClassThenInterfaceAdded),
        ("Adds a member to a class", testAddsMemberToClass),
    ]

}