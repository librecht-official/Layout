//
//  DeclarativeLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 09.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public protocol FrameHolder: AnyObject {
    var frame: CGRect { get set }
}

public protocol LayoutComponent {
    func performLayout(inFrame frame: CGRect)
}

// MARK: - Component
/// Leaf node of the layout tree.
///
/// Basic leaf `LayoutComponent` which calculates frame for it's `frameHolder`.
public struct Component<View: FrameHolder>: LayoutComponent {
    public let view: View
    public let h: HorizontalLayoutRule
    public let v: VerticalLayoutRule
    
    public init(_ view: View) {
        self.init(view, .zero, .zero)
    }
    
    public init(_ view: View, _ h: HorizontalLayoutRule, _ v: VerticalLayoutRule) {
        self.view = view
        self.h = h
        self.v = v
    }
    
    public func performLayout(inFrame frame: CGRect) {
        view.frame = layout(LayoutRules(h: h, v: v), inFrame: frame)
    }
}

extension Component: WidthAware where View: WidthAware {
    public func size(ifHeight height: CGFloat) -> CGSize {
        return view.size(ifHeight: height)
    }
}

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

// MARK: - AspectRatioComponent
/// Leaf node of the layout tree with aspect ratio layout rule.
///
/// Leaf `LayoutComponent` which calculates frame for it's `frameHolder` using special aspect ratio layout rule.
public struct AspectRatioComponent<View: FrameHolder>: LayoutComponent {
    public let view: View
    public let ratio: CGFloat
    public let suplementingRule: AspectRatioSupplementingLayoutRule
    
    public init(
        _ view: View,
        ratio: CGFloat,
        _ suplementingRule: AspectRatioSupplementingLayoutRule) {
        
        self.view = view
        self.ratio = ratio
        self.suplementingRule = suplementingRule
    }
    
    public func performLayout(inFrame frame: CGRect) {
        view.frame = layout(aspectRatio: ratio, suplementingRule, inFrame: frame)
    }
}

// MARK: - EmptyComponent
/// Convenience empty leaf node of the layout tree.
///
/// Usefull to describe empty (placeholder) spaces inside stack layout.
public struct EmptyComponent: LayoutComponent {
    public init() {
    }
    
    public func performLayout(inFrame frame: CGRect) {
    }
}

public struct Insets {
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(
        top: CGFloat = 0, bottom: CGFloat = 0,
        leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
    
    static let zero = Insets()
}

// MARK: - FitHeightAwareLayoutComponent
public typealias FitHeightAwareLayoutComponent = LayoutComponent & HeightAware

// MARK: - ColumnItem
public enum ColumnItem {
    case fixed(height: StackItemLength, LayoutComponent, Insets)
    
    public static func fixed(height: StackItemLength, _ c: LayoutComponent) -> ColumnItem {
        return .fixed(height: height, c, .zero)
    }
    
    case lessThenOrEqual(CGFloat, FitHeightAwareLayoutComponent, Insets)
    
    public static func lessThenOrEqual(_ max: CGFloat, c: FitHeightAwareLayoutComponent) -> ColumnItem {
        return .lessThenOrEqual(max, c, .zero)
    }
    
    //    case moreThenOrEqual(CGFloat, FitWidthAwareLayoutComponent)
    //    case moreThenOrEqual(CGFloat, FitWidthAwareLayoutComponent, Insets)
    //    case aspectRatio(CGFloat, FitWidthAwareLayoutComponent)
    //    case aspectRatio(CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    var inner: LayoutComponent {
        switch self {
        case let .fixed(height: _, component, _):
            return component
        case let .lessThenOrEqual(_, component, _):
            return component
        }
    }
    
    func height(ifStackWidth width: CGFloat) -> StackItemLength {
        switch self {
        case let .fixed(height, _, _):
            return height
        case let .lessThenOrEqual(maxHeight, component, _):
            let height = min(component.size(ifWidth: width).height, maxHeight)
            return .abs(height)
        }
    }
    
    var insets: Insets {
        switch self {
        case let .fixed(_, _, insets):
            return insets
        case let .lessThenOrEqual(_, _, insets):
            return insets
        }
    }
}

// MARK: - Column
/// Vertical fixed-size stack
public struct Column: LayoutComponent {
    public let spacing: CGFloat
    public let alignment: StackAlignment
    public let items: [ColumnItem]
    
    public init(
        spacing: CGFloat,
        alignment: StackAlignment = .evenlySpacing,
        _ items: [ColumnItem]) {
        
        self.spacing = spacing
        self.alignment = alignment
        self.items = items
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stackColumn(
            spacing: spacing, alignment: alignment, items.map { item -> StackItem in
                return StackItem(
                    { item.inner.performLayout(inFrame: $0) },
                    length: item.height(ifStackWidth: frame.width),
                    top: item.insets.top, bottom: item.insets.bottom,
                    leading: item.insets.leading, trailing: item.insets.trailing
                )
            },
            inFrame: frame
        )
    }
}

// MARK: - FitWidthAwareLayoutComponent
public typealias FitWidthAwareLayoutComponent = LayoutComponent & WidthAware

// MARK: - RowItem
public enum RowItem {
    case fixed(width: StackItemLength, LayoutComponent, Insets)
    
    public static func fixed(width: StackItemLength, _ c: LayoutComponent) -> RowItem {
        return .fixed(width: width, c, .zero)
    }
    
    case lessThenOrEqual(CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    public static func lessThenOrEqual(_ max: CGFloat, _ c: FitWidthAwareLayoutComponent) -> RowItem {
        return .lessThenOrEqual(max, c, .zero)
    }
    
    //    case moreThenOrEqual(CGFloat, FitWidthAwareLayoutComponent)
    //    case moreThenOrEqual(CGFloat, FitWidthAwareLayoutComponent, Insets)
    //    case aspectRatio(CGFloat, FitWidthAwareLayoutComponent)
    //    case aspectRatio(CGFloat, FitWidthAwareLayoutComponent, Insets)
    
    var inner: LayoutComponent {
        switch self {
        case let .fixed(_, component, _):
            return component
        case let .lessThenOrEqual(_, component, _):
            return component
        }
    }
    
    func width(ifStackHeight height: CGFloat) -> StackItemLength {
        switch self {
        case let .fixed(width, _, _):
            return width
        case let .lessThenOrEqual(maxWidth, component, _):
            let width = min(component.size(ifHeight: height).width, maxWidth)
            return .abs(width)
        }
    }
    
    var insets: Insets {
        switch self {
        case let .fixed(_, _, insets):
            return insets
        case let .lessThenOrEqual(_, _, insets):
            return insets
        }
    }
}

// MARK: - Row
/// Horizontal fixed-size stack
public struct Row: LayoutComponent {
    public let spacing: CGFloat
    public let alignment: StackAlignment
    public let items: [RowItem]
    
    public init(
        spacing: CGFloat,
        alignment: StackAlignment = .evenlySpacing,
        _ items: [RowItem]) {
        
        self.spacing = spacing
        self.alignment = alignment
        self.items = items
    }
    
    public func performLayout(inFrame frame: CGRect) {
        stackRow(
            spacing: spacing, alignment: alignment, items.map { item -> StackItem in
                return StackItem(
                    { item.inner.performLayout(inFrame: $0) },
                    length: item.width(ifStackHeight: frame.height),
                    top: item.insets.top, bottom: item.insets.bottom,
                    leading: item.insets.leading, trailing: item.insets.trailing
                )
            },
            inFrame: frame
        )
    }
}
