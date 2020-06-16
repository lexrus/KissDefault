//
//  StructTests.swift
//  KissDefaultTests
//
//  Created by Lex on 2020/6/14.
//  Copyright © 2020 Lex Tang. All rights reserved.
//

import XCTest
@testable import KissDefault

struct ObjStruct: Equatable, Codable {
    var wrappedValue: Int = 1024

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

struct StructCases {

    @Kiss(default: "I'm not instance")
    static var staticVar: String

    @Kiss(default: true)
    static var boolVar: Bool

    @Kiss()
    static var objV1: ObjStruct?

    @Kiss(default: 1)
    static var V1V1V1: Int

    @Kiss(default: "I'm not static")
    var instanceVar: String

    @Kiss(default: 22)
    var intV2ar: Int

    @Kiss()
    var kissOptional: String?

    @Kiss(default: "hello")
    var kissOptionalUnwrap: String?

    @KissCodable(default: ObjStruct(wrappedValue: 2048))
    var objV2: ObjStruct

}

class StructTests: XCTestCase {

    override func setUpWithError() throws {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        StructCases.staticVar = "new static var"
        StructCases.boolVar = false
        StructCases.objV1 = nil
        StructCases.V1V1V1 = 0

        var instance = StructCases()
        instance.instanceVar = "new instance var"
        instance.intV2ar = 33
        instance.objV2 = ObjStruct(wrappedValue: 2048)

        XCTAssertEqual(instance.objV2.wrappedValue, 2048)
    }

    func testStructCases() throws {
        XCTAssertEqual(StructCases.staticVar, "new static var")
        XCTAssertEqual(StructCases.V1V1V1, 0)
        XCTAssertEqual(StructCases.boolVar, false)
        XCTAssertEqual(StructCases.objV1, nil)

        var cases = StructCases()

        XCTAssertEqual(cases.instanceVar, "new instance var")
        XCTAssertEqual(cases.intV2ar, 33)
        XCTAssertEqual(cases.objV2.wrappedValue, 2048)

        XCTAssertEqual(cases.kissOptionalUnwrap, "hello")
        cases.kissOptionalUnwrap = "world"
        XCTAssertEqual(cases.kissOptionalUnwrap, "world")
    }

}
