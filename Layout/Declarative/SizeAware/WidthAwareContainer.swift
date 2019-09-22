//
//  WidthAwareContainer.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

/// Wrapper-component for Container of WidthAware
public struct WidthAwareContainer: WidthAwareLayoutComponent {
    public let frameHolder: FrameHolder?
    public let inner: WidthAwareLayoutComponent
    public let v: VerticalLayoutRule
    public let leading, trailing: CGFloat
    public let relative: Bool
    
    public init(
        _ frameHolder: FrameHolder?,
        v: VerticalLayoutRule, leading: CGFloat, trailing: CGFloat,
        relative: Bool = true, inner: WidthAwareLayoutComponent) {
        
        self.frameHolder = frameHolder
        self.inner = inner
        self.v = v
        self.leading = leading
        self.trailing = trailing
        self.relative = relative
    }
    
    public func performLayout(inOrigin origin: CGPoint, height: CGFloat) -> CGFloat {
        // selfWidth is inner's total width
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (y1, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        let selfY = origin.y + y1
        let selfX = origin.x + leading
        let innerOrigin = relative ? CGPoint(x: 0, y: 0) : CGPoint(x: selfX, y: selfY)
        let innerTotalWidth = inner.performLayout(inOrigin: innerOrigin, height: selfHeight)
        let selfWidth = innerTotalWidth
        let selfSize = CGSize(width: selfWidth, height: selfHeight)
        let selfOrigin = CGPoint(x: selfX, y: selfY)
        frameHolder?.frame = CGRect(origin: selfOrigin, size: selfSize)
        return totalWidth(ifSelfWidth: selfWidth)
    }
    
    public func size(ifHeight height: CGFloat) -> CGSize {
        let verticalBounds = CGRect(origin: .zero, size: CGSize(width: 0, height: height))
        let (_, selfHeight) = verticalLayout(rule: v, inBounds: verticalBounds)
        let innerTotalWidth = inner.size(ifHeight: selfHeight).width
        let selfWidth = innerTotalWidth
        return CGSize(width: totalWidth(ifSelfWidth: selfWidth), height: selfHeight)
    }
    
    func totalWidth(ifSelfWidth width: CGFloat) -> CGFloat {
        return width + leading + trailing
    }
}
