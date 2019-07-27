//
//  DeclarativeLayoutAPITests.swift
//  LayoutDSLTests
//
//  Created by Vladislav Librecht on 09.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import XCTest
@testable import Layout

final class ViewMock: FrameHolder {
    var frame: CGRect = .zero
}

final class HeightAwareViewMock: FrameHolder, HeightAware {
    var frame: CGRect = .zero
    let sizeIfWidth: (CGFloat) -> CGSize
    
    init(_ sizeIfWidth: @escaping (CGFloat) -> CGSize) {
        self.sizeIfWidth = sizeIfWidth
    }
    
    func size(ifWidth width: CGFloat) -> CGSize {
        return sizeIfWidth(width)
    }
}

class DeclarativeLayoutAPITests: XCTestCase {
    func testComponent() {
        let w = CGFloat(200)
        let h = CGFloat(100)
        let bounds = CGRect(x: 0, y: 0, width: w, height: h)
        let view = ViewMock()
        let c = Component(view, .h1(leading: 8, trailing: 8), .v1(top: 10, bottom: 10))
        c.performLayout(inFrame: bounds)
        
        XCTAssert(view.frame == CGRect(x: 8, y: 10, width: w - 16, height: h - 20))
    }
    
    func testContainer() {
        let w = CGFloat(200)
        let h = CGFloat(100)
        let bounds = CGRect(x: 0, y: 0, width: w, height: h)
        let container = ViewMock()
        let view = ViewMock()
        
        let containerLayout: (Bool) -> Container = { relative in
            Container(
                container,
                h: .h4(centerX: .abs(0), width: .abs(50)),
                v: .v4(centerY: .abs(0), height: .abs(40)),
                relative: relative,
                inner: Component(
                    view, .h1(leading: 8, trailing: 8), .v1(top: 10, bottom: 10)
                )
            )
        }
        
        // Component layout is not tied (not a subview) with Container
        let absoluteContainer = containerLayout(false)
        absoluteContainer.performLayout(inFrame: bounds)
        XCTAssert(container.frame == CGRect(x: 75, y: 30, width: 50, height: 40))
        XCTAssert(view.frame == CGRect(x: 83, y: 40, width: 50 - 16, height: 40 - 20))
        
        // Component layout is relative (is subview) to Container
        let relativeContainer = containerLayout(true)
        relativeContainer.performLayout(inFrame: bounds)
        XCTAssert(container.frame == CGRect(x: 75, y: 30, width: 50, height: 40))
        XCTAssert(view.frame == CGRect(x: 8, y: 10, width: 50 - 16, height: 40 - 20))
    }
    
    func testNestedContainers() {
        let w = CGFloat(200)
        let h = CGFloat(100)
        let bounds = CGRect(x: 0, y: 0, width: w, height: h)
        let container1 = ViewMock()
        let container2 = ViewMock()
        let container3 = ViewMock()
        let view = ViewMock()
        
        let c = Container(
            container1,
            h: .h1(leading: 8, trailing: 8), v: .v1(top: 8, bottom: 8), relative: false,
            inner: Container(
                container2,
                h: .h1(leading: 8, trailing: 8), v: .v1(top: 8, bottom: 8), relative: true,
                inner: Container(
                    container3,
                    h: .h1(leading: 8, trailing: 8), v: .v1(top: 8, bottom: 8), relative: false,
                    inner: Component(
                        view, .h1(leading: 8, trailing: 8), .v1(top: 8, bottom: 8)
                    )
                )
            )
        )
        c.performLayout(inFrame: bounds)
        XCTAssertEqual(container1.frame, CGRect(x: 8, y: 8, width: w - 16, height: h - 16))
        XCTAssertEqual(container2.frame, CGRect(x: 16, y: 16, width: w - 32, height: h - 32))
        XCTAssertEqual(container3.frame, CGRect(x: 8, y: 8, width: w - 32 - 16, height: h - 32 - 16))
        XCTAssertEqual(view.frame, CGRect(x: 16, y: 16, width: w - 32 - 32, height: h - 32 - 32))
    }
    
    func testColumn() {
        let w = CGFloat(100)
        let h = CGFloat(200)
        let bounds = CGRect(x: 0, y: 0, width: w, height: h)
        let v1 = ViewMock()
        let v2 = ViewMock()
        let v3 = ViewMock()
        let c = Column(spacing: 8, [
            ColumnItem(
                Component(v1, .h1(leading: 8, trailing: 12), .v1(top: 15, bottom: 10)),
                length: .abs(64), bottom: 8
            ),
            ColumnItem(
                Container(
                    v2,
                    h: .h4(centerX: .abs(0), width: .abs(50)),
                    v: .v4(centerY: .abs(0), height: .abs(40)),
                    inner: Component(
                        v3, .h1(leading: 15, trailing: 8), .v1(top: 10, bottom: 18)
                    )
                ),
                length: .weight(1)
            )
        ])
        c.performLayout(inFrame: bounds)
        XCTAssertEqual(v1.frame, CGRect(x: 8, y: 15, width: 80, height: 39))
        XCTAssertEqual(v2.frame, CGRect(x: 25, y: 120, width: 50, height: 40))
        XCTAssertEqual(v3.frame, CGRect(x: 15, y: 10, width: 27, height: 12))
    }
    
    func testSingleSquareHeigtAwareComponentInsideColumn() {
        let width = CGFloat(200)
        let square = HeightAwareViewMock({ CGSize(width: $0, height: $0) })
        
        let column = HeightAwareColumn(spacing: 8, [
            .automatic(
                HeightAwareComponent(
                    square, h: .h4(centerX: .abs(40), width: .rel(0.5)), top: 30, bottom: 10
                )
            )
            ])
        let height = column.performLayout(inOrigin: .zero, width: width)
        let expectedHeight = CGFloat(30 + 100 + 10)
        XCTAssertEqual(height, expectedHeight)
        XCTAssertEqual(square.frame, CGRect(x: 90, y: 30, width: 100, height: 100))
    }
    
    func testComplexHeightAwareColumn() {
        let w = CGFloat(200)
        let v1 = ViewMock()
        let l1 = ViewMock()
        let v2 = ViewMock()
        let l2 = HeightAwareViewMock({ CGSize(width: $0, height: $0) })
        let l3 = HeightAwareViewMock({ CGSize(width: $0, height: 0.5 * $0) })
        
        let column = HeightAwareColumn(spacing: 8, [
            .fixed(
                height: 90,
                Container(
                    v1, h: .h1(leading: 8, trailing: 8), v: .v1(top: 10, bottom: 10),
                    inner: Component(
                        l1, .h1(leading: 12, trailing: 8), .v1(top: 8, bottom: 8)
                    )
                )
            ),
            .fixed(height: 20, EmptyComponent()),
            .automatic(
                HeightAwareContainer(
                    v2, h: .h4(centerX: .abs(0), width: .rel(0.8)), top: 8, bottom: 8,
                    inner: HeightAwareComponent(l2, top: 10, bottom: 20)
                )
            ),
            .automatic(
                HeightAwareContainer(
                    nil, h: .h1(leading: 8, trailing: 8), top: 0, bottom: 0, relative: false,
                    inner: HeightAwareComponent(l3)
                )
            )
        ])
        let height = column.performLayout(inOrigin: .zero, width: w)
        XCTAssertEqual(height, 432)
        
        XCTAssertEqual(v1.frame, CGRect(x: 8, y: 10, width: w - 16, height: 90 - 20))
        XCTAssertEqual(l1.frame, CGRect(x: 12, y: 8, width: w - 16 - 20, height: 90 - 20 - 16))
        XCTAssertEqual(v2.frame, CGRect(x: 20, y: 134, width: 160, height: 190))
        XCTAssertEqual(l2.frame, CGRect(x: 0, y: 10, width: 160, height: 160))
        XCTAssertEqual(l3.frame, CGRect(x: 8, y: 340, width: 184, height: 92))
    }
}
