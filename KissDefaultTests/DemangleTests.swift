//
//  DemangleTests.swift
//  KissDefaultTests
//
//  Created by Lex on 2020/6/14.
//  Copyright © 2020 Lex Tang. All rights reserved.
//

import XCTest
@testable import KissDefault

class DemangleTests: XCTestCase {

    func testDemangle() throws {
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV5objV2AA03ObjD0Vvs"), "objV2")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests3ClsC9staticVarSSvgZ"), "staticVar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests3ClsC9normalVarSSvg"), "normalVar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests3ClsC7intV1ars5Int64Vvg"), "intV1ar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests5FinalC11finalStatics5Int32VvgZ"), "finalStatic")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests5FinalC5finals5Int32Vvg"), "final")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests5FinalC6V2V3V433_B6ED8419C42C1C2105B77B5DC33ED211LLSbSgvg"), "V2V3V4")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV5objV2AA03ObjD0Vvs"), "objV2")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV9staticVarSSvsZ"), "staticVar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV7boolVarSbvsZ"), "boolVar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV5objV1AA03ObjD0VSgvsZ"), "objV1")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV11instanceVarSSvs"), "instanceVar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV7intV2arSivs"), "intV2ar")
        XCTAssertEqual(demangleVariableName(of: "$s16KissDefaultTests11StructCasesV7boolVarSbvgZ"), "boolVar")

    }

    func testDemanglePerformance() throws {
        self.measure {
            for _ in 0..<1000 {
                if demangleVariableName(of: "$s9SomeTests11StructCasesV5objV2AA03ObjD0Vvs") != "objV2" {
                    XCTFail()
                }
            }
        }
    }

}
