//
//  ClassTests.swift
//  KissDefaultTests
//
//  Created by Lex on 2020/6/12.
//  Copyright © 2020 Lex Tang. All rights reserved.
//

import XCTest
@testable import KissDefault


public class Cls {

    @Kiss(default: "Reo")
    static var staticVar: String

    @Kiss(default: "normal")
    var normalVar: String

    @Kiss(default: 1024)
    var intV1ar: Int64

}

final class Final: Cls {

    @Kiss(default: 99)
    static var finalStatic: Int32

    @Kiss(default: 88)
    public var final: Int32

    @Kiss(default: true)
    fileprivate var boolVar: Bool?
}

class ClassTests: XCTestCase {

    override func setUpWithError() throws {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    func testClassCases() throws {
//        let cls = Cls()
//
//        XCTAssertEqual(Cls.staticVar, "Reo")
//
//        Cls.staticVar = "hello"
//        XCTAssertEqual(Cls.staticVar, "hello")
//
//        XCTAssertEqual(cls.normalVar, "normal")
//        XCTAssertEqual(cls.intV1ar, 1024)

        let final = Final()
//        XCTAssertEqual(Final.finalStatic, 99)
        XCTAssertEqual(final.final, 88)
        XCTAssertEqual(final.boolVar, true)
    }

}
