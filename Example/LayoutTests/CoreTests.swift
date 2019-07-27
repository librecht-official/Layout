//
//  LayoutDSLTests.swift
//  LayoutDSLTests
//
//  Created by Vladislav Librecht on 09.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
@testable import Layout

class CoreTests: XCTestCase {
    func testAspectRatioLayout() {
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 400)
        
        let r1 = layout(
            aspectRatio: 0.8,
            .h(.h1(leading: 8, trailing: 8), and: .centerY(.abs(16))),
            inBounds: bounds
        )
        
        XCTAssert(r1 == CGRect(x: 8, y: 101, width: 184, height: 230))
        
        let r2 = layout(
            aspectRatio: 0.5,
            .v(.v4(centerY: .rel(0.8), height: .rel(0.75)), and: .centerX(.abs(8))),
            inBounds: bounds
        )
        
        XCTAssert(r2 == CGRect(x: 33, y: 10, width: 150, height: 300))
    }

    func testHorizontalLayout() {
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 0)
        
        let r41 = horizontalLayout(rule: .h4(centerX: .abs(19), width: .abs(57)), inBounds: bounds)
        XCTAssert(r41.x == 90.5)
        XCTAssert(r41.width == 57)
        
        let r42 = horizontalLayout(rule: .h4(centerX: .rel(1.2), width: .rel(0.35)), inBounds: bounds)
        XCTAssert(r42.x == 85)
        XCTAssert(r42.width == 70)
        
        let r5 = horizontalLayout(rule: .h5(centerX: .rel(1.2), leading: 46), inBounds: bounds)
        XCTAssert(r5.x == 46)
        XCTAssert(r5.width == 148)
        
        let r6 = horizontalLayout(rule: .h6(centerX: .rel(1.2), trailing: 6), inBounds: bounds)
        XCTAssert(r6.x == 46)
        XCTAssert(r6.width == 148)
    }
    
    func testVerticalLayout() {
        let bounds = CGRect(x: 0, y: 0, width: 0, height: 200)
        
        let r41 = verticalLayout(rule: .v4(centerY: .abs(19), height: .abs(57)), inBounds: bounds)
        XCTAssert(r41.y == 90.5)
        XCTAssert(r41.height == 57)
        
        let r42 = verticalLayout(rule: .v4(centerY: .rel(1.2), height: .rel(0.35)), inBounds: bounds)
        XCTAssert(r42.y == 85)
        XCTAssert(r42.height == 70)
        
        let r5 = verticalLayout(rule: .v5(centerY: .rel(1.2), top: 46), inBounds: bounds)
        XCTAssert(r5.y == 46)
        XCTAssert(r5.height == 148)
        
        let r6 = verticalLayout(rule: .v6(centerY: .rel(1.2), bottom: 6), inBounds: bounds)
        XCTAssert(r6.y == 46)
        XCTAssert(r6.height == 148)
    }
    
    func testStackColumnLayout() {
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 420)
        
        var v1: CGRect = .zero
        var v2: CGRect = .zero
        var v3: CGRect = .zero
        stackColumn(
            spacing: 8, [
                StackItem({ v1 = $0 }, length: .abs(64), top: 8, bottom: 0, leading: 8, trailing: 8),
                StackItem({ v2 = $0 }, length: .weight(1), top: 0, bottom: 20, leading: 16, trailing: 16),
                StackItem({ v3 = $0 }, length: .weight(2), top: 0, bottom: 0, leading: 20, trailing: 0),
                ],
            inFrame: bounds
        )
        
        XCTAssertEqual(v1, CGRect(x: 8, y: 8, width: 184, height: 64))
        XCTAssertEqual(v2, CGRect(x: 16, y: 80, width: 168, height: 104))
        XCTAssertEqual(v3, CGRect(x: 20, y: 212, width: 180, height: 208))
    }
    
    func testStackRowLayout() {
        let bounds = CGRect(x: 0, y: 0, width: 420, height: 200)
        
        var v1: CGRect = .zero
        var v2: CGRect = .zero
        var v3: CGRect = .zero
        stackRow(
            spacing: 8, [
                StackItem({ v1 = $0 }, length: .abs(64), top: 8, bottom: 8, leading: 8, trailing: 0),
                StackItem({ v2 = $0 }, length: .weight(1), top: 16, bottom: 16, leading: 0, trailing: 20),
                StackItem({ v3 = $0 }, length: .weight(2), top: 20, bottom: 0, leading: 0, trailing: 0),
            ],
            inFrame: bounds
        )
        
        XCTAssertEqual(v1, CGRect(x: 8, y: 8, width: 64, height: 184))
        XCTAssertEqual(v2, CGRect(x: 80, y: 16, width: 104, height: 168))
        XCTAssertEqual(v3, CGRect(x: 212, y: 20, width: 208, height: 180))
    }
}
