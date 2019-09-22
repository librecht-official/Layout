//
//  Container.swift
//  Layout
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

// MARK: - Container
/// Non leaf node of the layout tree.
///
/// Works the same as `Component` but additionally have sub-component. Use `relative: false` if inner's view is not a subview of this container's view, e.g. if `frameHolder` is `nil`.
public struct Container<View: FrameHolder>: LayoutComponent {
    public let view: View?
    public let inner: LayoutComponent
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    public let relative: Bool
    
    public init(
        _ view: View? = nil,
        _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule,
        relative: Bool = true, inner: LayoutComponent) {
        
        self.view = view
        self.inner = inner
        self.h = h
        self.v = v
        self.relative = relative
    }
    
    public func performLayout(inFrame frame: CGRect) {
        let containerFrame = layout(LayoutRules(h: h, v: v), inFrame: frame)
        view?.frame = containerFrame
        let frame = relative ? containerFrame.bounds : containerFrame
        inner.performLayout(inFrame: frame)
    }
}
