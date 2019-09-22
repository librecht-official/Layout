//
//  RowTests.swift
//  LayoutTests
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
import Layout
@testable import LayoutExample

class RowTests: XCTestCase {
    func testRow_LessThanRuleView() {
        let frame = CGRect(x: 0, y: 0, width: 316, height: 10000)
        let view = RowWithLessThanRuleView(frame: frame)
        
        view.layoutComponent.performLayout(inFrame: frame)
        
        XCTAssertEqual(view.v11.frame, CGRect(x: 8.0, y: 8.0, width: 84.0, height: 40.0))
        XCTAssertEqual(view.v12.frame, CGRect(x: 16.0, y: 64.0, width: 68.0, height: 30.0))
        XCTAssertEqual(view.v13.frame, CGRect(x: 16.0, y: 118.0, width: 68.0, height: 68.0))
        XCTAssertEqual(view.v21.frame, CGRect(x: 116.0, y: 8.0, width: 84.0, height: 40.0))
        XCTAssertEqual(view.v22.frame, CGRect(x: 124.0, y: 4963.0, width: 68.0, height: 30.0))
        XCTAssertEqual(view.v23.frame, CGRect(x: 124.0, y: 9916.0, width: 68.0, height: 68.0))
        XCTAssertEqual(view.v31.frame, CGRect(x: 224.0, y: 9806.0, width: 84.0, height: 40.0))
        XCTAssertEqual(view.v32.frame, CGRect(x: 232.0, y: 9862.0, width: 68.0, height: 30.0))
        XCTAssertEqual(view.v33.frame, CGRect(x: 232.0, y: 9916.0, width: 68.0, height: 68.0))

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
