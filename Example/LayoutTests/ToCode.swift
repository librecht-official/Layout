//
//  PrintCode.swift
//  LayoutTests
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

func toCode(_ framePath: String,_ rect: CGRect) -> String {
    return "XCTAssertEqual(\(framePath), \(toCode(rect)))"
}

func toCode(_ rect: CGRect) -> String {
    return "CGRect(x: \(rect.origin.x), y: \(rect.origin.y), width: \(rect.size.width), height: \(rect.size.height))"
}
