//
//  ColumnTests.swift
//  LayoutTests
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
import Layout
@testable import LayoutExample

class ColumnTests: XCTestCase {
    func testColumn_LessThanRuleView() {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 400)
        let view = ColumnWithLessThanRuleView(frame: frame)
        
        view.layoutComponent.performLayout(inFrame: frame)
        
        XCTAssertEqual(view.v11.frame, CGRect(x: 8.0, y: 8.0, width: 40.0, height: 112.0))
        XCTAssertEqual(view.v12.frame, CGRect(x: 64.0, y: 16.0, width: 30.0, height: 96.0))
        XCTAssertEqual(view.v13.frame, CGRect(x: 118.0, y: 16.0, width: 70.0, height: 96.0))
        XCTAssertEqual(view.v21.frame, CGRect(x: 8.0, y: 144.0, width: 40.0, height: 112.0))
        XCTAssertEqual(view.v22.frame, CGRect(x: 149.5, y: 152.0, width: 30.0, height: 96.0))
        XCTAssertEqual(view.v23.frame, CGRect(x: 289.0, y: 152.0, width: 70.0, height: 96.0))
        XCTAssertEqual(view.v31.frame, CGRect(x: 179.0, y: 280.0, width: 40.0, height: 112.0))
        XCTAssertEqual(view.v32.frame, CGRect(x: 235.0, y: 288.0, width: 30.0, height: 96.0))
        XCTAssertEqual(view.v33.frame, CGRect(x: 289.0, y: 288.0, width: 70.0, height: 96.0))
        
//        print(toCode("view.v11.frame", view.v11.frame))
//        print(toCode("view.v12.frame", view.v12.frame))
//        print(toCode("view.v13.frame", view.v13.frame))
//        print(toCode("view.v21.frame", view.v21.frame))
//        print(toCode("view.v22.frame", view.v22.frame))
//        print(toCode("view.v23.frame", view.v23.frame))
//        print(toCode("view.v31.frame", view.v31.frame))
//        print(toCode("view.v32.frame", view.v32.frame))
//        print(toCode("view.v33.frame", view.v33.frame))
    }
}
