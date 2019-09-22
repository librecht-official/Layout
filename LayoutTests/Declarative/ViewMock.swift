//
//  ViewMock.swift
//  LayoutTests
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreFoundation
import Layout

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

final class WidthAwareViewMock: FrameHolder, WidthAware {
    var frame: CGRect = .zero
    let sizeIfHeight: (CGFloat) -> CGSize
    
    init(_ sizeIfHeight: @escaping (CGFloat) -> CGSize) {
        self.sizeIfHeight = sizeIfHeight
    }
    
    func size(ifHeight height: CGFloat) -> CGSize {
        return sizeIfHeight(height)
    }
}
