//
//  M_A_C_Tests.swift
//  M.A.C.Tests
//
//  Created by iki on 16/07/14.
//  Copyright (c) 2014 Iki. All rights reserved.
//

import UIKit
import XCTest

class M_A_C_Tests: XCTestCase {

    // MARK: Default test cases
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: ???
    func testMACAddressValidRegexWithCustomOperator() {
        XCTAssert("00:00:00:00:00:00" =~ kValidMACAddressRegex, "INVALID mac address")
        XCTAssert("00-00-00-00-00-00" =~ kValidMACAddressRegex, "INVALID mac address")
        XCTAssert("000000000000" =~ kValidMACAddressRegex, "INVALID mac address")
        XCTAssert("00.00.00.00.00.00" =~ kValidMACAddressRegex, "INVALID mac address")
        XCTAssert("0000.0000.0000" =~ kValidMACAddressRegex, "INVALID mac address")
        XCTAssert("AA00.CC00.DD00" =~ kValidMACAddressRegex, "INVALID mac address")
    }

}
