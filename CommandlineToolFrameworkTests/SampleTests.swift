//
//  SampleTests.swift
//  CommandlineTool
//
//  Created by Yusuke Kita on 7/19/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import XCTest
import CommandlineToolFramework

class SampleTests: XCTestCase {
    func testInitialize() {
        let text = Sample(text: "foo")
        XCTAssert(text == nil, "error")
    }
}
