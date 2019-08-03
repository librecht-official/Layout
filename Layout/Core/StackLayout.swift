//
//  StackLayout.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 01.05.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import CoreGraphics

public enum StackItemLength {
    case abs(CGFloat)
    case weight(CGFloat)
    
    func value(totalWeight: CGFloat, totalWeightedLength: CGFloat) -> CGFloat {
        switch self {
        case let .abs(val):
            return val
        case let .weight(w):
            guard totalWeight > 0 else { return 0 }
            return w / totalWeight * totalWeightedLength
        }
    }
}

public enum StackAlignment {
    case start, end, evenlySpacing
}

public struct StackItem {
    public typealias LayoutOutput = (CGRect) -> ()
    public let output: LayoutOutput
    public let length: StackItemLength
    public let top: CGFloat
    public let bottom: CGFloat
    public let leading: CGFloat
    public let trailing: CGFloat
    
    public init(
        _ output: @escaping LayoutOutput, length: StackItemLength,
        top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        self.output = output
        self.length = length
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
}

// MARK: - stackColumn
/// Calculates frames for each item in fixed-size stacked column.
///
/// If there is no enougn space, items with weighted height will have 0 height.
/// If free space remains and there are weighted items they will occupy this free space.
/// If free space remains and there are **no** weighted items it uses alignment.
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackColumn(
    spacing: CGFloat,
    alignment: StackAlignment,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    var totalAbsoluteItemsHeight = CGFloat(0)
    var totalWeight = CGFloat(0)
    var haveWeightedItem = false
    for item in items {
        switch item.length {
        case let .abs(h):
            totalAbsoluteItemsHeight += (h + item.top + item.bottom)
        case let .weight(w):
            haveWeightedItem = true
            totalAbsoluteItemsHeight += item.top + item.bottom
            totalWeight += w
        }
    }
    totalAbsoluteItemsHeight += spacing * CGFloat(items.count - 1)
    
    let input = ItemsFramesCalculationInput(
        spacing: spacing,
        items: items,
        frame: frame,
        totalAbsoluteItemsLength: totalAbsoluteItemsHeight,
        totalWeight: totalWeight
    )
    
    if haveWeightedItem {
        return calculateItemsFramesForTopAlignment(input)
    }
    switch alignment {
    case .start:
        return calculateItemsFramesForTopAlignment(input)
    case .end:
        return calculateItemsFramesForBottomAlignment(input)
    case .evenlySpacing:
        return calculateItemsFramesForEvenlySpacingColumnAlignment(input)
    }
}

struct ItemsFramesCalculationInput {
    let spacing: CGFloat
    let items: [StackItem]
    let frame: CGRect
    let totalAbsoluteItemsLength: CGFloat
    let totalWeight: CGFloat
}

func calculateItemsFramesForTopAlignment(_ input: ItemsFramesCalculationInput) -> [CGRect] {
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.height - input.totalAbsoluteItemsLength)
    
    var result = [CGRect]()
    var y = CGFloat(0)
    for item in input.items {
        let (x, w) = horizontalLayout(
            rule: .h1(leading: item.leading, trailing: item.trailing), inBounds: bounds
        )
        let h = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = CGRect(x: x, y: y + item.top, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        y += item.top + h + item.bottom + input.spacing
    }
    
    return result
}

func calculateItemsFramesForBottomAlignment(_ input: ItemsFramesCalculationInput) -> [CGRect] {
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.height - input.totalAbsoluteItemsLength)
    
    var result = [CGRect]()
    var y = input.totalAbsoluteItemsLength
    for item in input.items {
        let h = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        y -= item.bottom + h
        let (x, w) = horizontalLayout(
            rule: .h1(leading: item.leading, trailing: item.trailing), inBounds: bounds
        )
        let rect = CGRect(x: x, y: y, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        y -= item.top + input.spacing
    }
    
    return result
}

func calculateItemsFramesForEvenlySpacingColumnAlignment(
    _ input: ItemsFramesCalculationInput) -> [CGRect] {
    
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.height - input.totalAbsoluteItemsLength)
    
    guard input.items.count > 0 else { return [] }
    let spacing = input.spacing + freeSpace / CGFloat(input.items.count)
    
    var result = [CGRect]()
    var y = CGFloat(0)
    for item in input.items {
        let (x, w) = horizontalLayout(
            rule: .h1(leading: item.leading, trailing: item.trailing), inBounds: bounds
        )
        let h = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = CGRect(x: x, y: y + item.top, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        y += item.top + h + item.bottom + spacing
    }
    
    return result
}

// MARK: - stackRow
/// Calculates frames for each item in fixed-size stacked row.
///
/// If there is no enougn space, items with weighted width will have 0 width.
/// If free space remains and there are weighted items they will occupy this free space.
/// If free space remains and there are **no** weighted items it uses alignment.
/// Outputs result via StackItem.output and return value as well.
@discardableResult
public func stackRow(
    spacing: CGFloat,
    alignment: StackAlignment,
    _ items: [StackItem], inFrame frame: CGRect) -> [CGRect] {
    
    var totalAbsoluteItemsWidth = CGFloat(0)
    var totalWeight = CGFloat(0)
    var haveWeightedItem = false
    for item in items {
        switch item.length {
        case let .abs(w):
            totalAbsoluteItemsWidth += (w + item.leading + item.trailing)
        case let .weight(w):
            haveWeightedItem = true
            totalAbsoluteItemsWidth += item.leading + item.trailing
            totalWeight += w
        }
    }
    totalAbsoluteItemsWidth += spacing * CGFloat(items.count - 1)
    
    let input = ItemsFramesCalculationInput(
        spacing: spacing,
        items: items,
        frame: frame,
        totalAbsoluteItemsLength: totalAbsoluteItemsWidth,
        totalWeight: totalWeight
    )
    
    if haveWeightedItem {
        return calculateItemsFramesForLeadingAlignment(input)
    }
    switch alignment {
    case .start:
        return calculateItemsFramesForLeadingAlignment(input)
    case .end:
        return calculateItemsFramesForTrailingAlignment(input)
    case .evenlySpacing:
        return calculateItemsFramesForEvenlySpacingRowAlignment(input)
    }
}

func calculateItemsFramesForLeadingAlignment(_ input: ItemsFramesCalculationInput) -> [CGRect] {
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.width - input.totalAbsoluteItemsLength)
    
    var result = [CGRect]()
    var x = CGFloat(0)
    for item in input.items {
        let (y, h) = verticalLayout(
            rule: .v1(top: item.top, bottom: item.bottom), inBounds: bounds
        )
        let w = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = CGRect(x: x + item.leading, y: y, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        x += item.leading + w + item.trailing + input.spacing
    }
    
    return result
}

func calculateItemsFramesForTrailingAlignment(_ input: ItemsFramesCalculationInput) -> [CGRect] {
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.width - input.totalAbsoluteItemsLength)
    
    var result = [CGRect]()
    var x = input.totalAbsoluteItemsLength
    for item in input.items {
        let w = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        x -= item.trailing - w
        let (y, h) = verticalLayout(
            rule: .v1(top: item.top, bottom: item.bottom), inBounds: bounds
        )
        let rect = CGRect(x: x + item.leading, y: y, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        x -= item.leading + input.spacing
    }
    
    return result
}

func calculateItemsFramesForEvenlySpacingRowAlignment(_ input: ItemsFramesCalculationInput) -> [CGRect] {
    let bounds = CGRect(origin: .zero, size: input.frame.size)
    let freeSpace = max(0, bounds.width - input.totalAbsoluteItemsLength)
    
    guard input.items.count > 0 else { return [] }
    let spacing = input.spacing + freeSpace / CGFloat(input.items.count)
    
    var result = [CGRect]()
    var x = CGFloat(0)
    for item in input.items {
        let (y, h) = verticalLayout(
            rule: .v1(top: item.top, bottom: item.bottom), inBounds: bounds
        )
        let w = item.length.value(totalWeight: input.totalWeight, totalWeightedLength: freeSpace)
        let rect = CGRect(x: x + item.leading, y: y, width: w, height: h)
            .offsetBy(dx: input.frame.origin.x, dy: input.frame.origin.y)
        item.output(rect)
        result.append(rect)
        x += item.leading + w + item.trailing + spacing
    }
    
    return result
}
