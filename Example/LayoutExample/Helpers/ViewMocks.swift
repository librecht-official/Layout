//
//  ViewMocks.swift
//  LayoutExample
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreFoundation
import Layout

final class ViewMock: FrameHolder {
    var frame: CGRect = .zero
}

final class HeightAwareViewMock: UIView, HeightAware {
    let sizeIfWidth: (CGFloat) -> CGSize
    
    init(_ sizeIfWidth: @escaping (CGFloat) -> CGSize) {
        self.sizeIfWidth = sizeIfWidth
        super.init(frame: .zero)
    }
    
    func size(ifWidth width: CGFloat) -> CGSize {
        return sizeIfWidth(width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class WidthAwareViewMock: UIView, WidthAware {
    let sizeIfHeight: (CGFloat) -> CGSize
    
    init(_ sizeIfHeight: @escaping (CGFloat) -> CGSize) {
        self.sizeIfHeight = sizeIfHeight
        super.init(frame: .zero)
    }
    
    func size(ifHeight height: CGFloat) -> CGSize {
        return sizeIfHeight(height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
