//
//  RowTests.swift
//  LayoutTests
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
@testable import Layout

class RowTests: XCTestCase {
    func testRow_StartDistribution_LessThanItem() {
        // Given
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 50)
        let v1 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v2 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v3 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        
        let row = Row(spacing: 20, distribution: .start, [
            RowItem.fixed(width: .abs(40), Component(v1)),
            RowItem.lessThanOrEqual(30, Component(v2), Insets(each: 8)),
            RowItem.lessThanOrEqual(70, Component(v3), Insets(each: 8)),
            ]
        )
        
        // When
        row.performLayout(inFrame: bounds)
        
        // Then
        XCTAssertEqual(v1.frame, CGRect(x: 0, y: 0, width: 40, height: 50))
        XCTAssertEqual(v2.frame, CGRect(x: 68, y: 8, width: 30, height: 34))
        XCTAssertEqual(v3.frame, CGRect(x: 134, y: 8, width: 34, height: 34))
    }
    
    func testRow_EndDistribution_LessThanItem() {
        // Given
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 50)
        let v1 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v2 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v3 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        
        let row = Row(spacing: 20, distribution: .end, [
            RowItem.fixed(width: .abs(40), Component(v1)),
            RowItem.lessThanOrEqual(30, Component(v2), Insets(each: 8)),
            RowItem.lessThanOrEqual(70, Component(v3), Insets(each: 8)),
            ]
        )
        
        // When
        row.performLayout(inFrame: bounds)
        
        // Then
        XCTAssertEqual(v1.frame, CGRect(x: 24, y: 0, width: 40, height: 50))
        XCTAssertEqual(v2.frame, CGRect(x: 92, y: 8, width: 30, height: 34))
        XCTAssertEqual(v3.frame, CGRect(x: 158, y: 8, width: 34, height: 34))
    }
    
    func testRow_EvenlySpacedDistribution_LessThanItem() {
        // Given
        let bounds = CGRect(x: 0, y: 0, width: 200, height: 50)
        let v1 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v2 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        let v3 = WidthAwareViewMock { CGSize(width: $0, height: $0) }
        
        let row = Row(spacing: 20, distribution: .evenlySpaced, [
            RowItem.fixed(width: .abs(40), Component(v1)),
            RowItem.lessThanOrEqual(30, Component(v2), Insets(each: 8)),
            RowItem.lessThanOrEqual(70, Component(v3), Insets(each: 8)),
            ]
        )
        
        // When
        row.performLayout(inFrame: bounds)
        
        // Then
        XCTAssertEqual(v1.frame, CGRect(x: 0, y: 0, width: 40, height: 50))
        XCTAssertEqual(v2.frame, CGRect(x: 80, y: 8, width: 30, height: 34))
        XCTAssertEqual(v3.frame, CGRect(x: 158, y: 8, width: 34, height: 34))
    }
}
