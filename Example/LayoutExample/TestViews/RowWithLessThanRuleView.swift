//
//  RowWithLessThanRuleView.swift
//  LayoutExample
//
//  Created by Vladislav Librecht on 22/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Layout

final class RowWithLessThanRuleView: UIView {
    lazy var v11 = UIView()
    lazy var v12 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    lazy var v13 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    
    lazy var v21 = UIView()
    lazy var v22 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    lazy var v23 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    
    lazy var v31 = UIView()
    lazy var v32 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    lazy var v33 = HeightAwareViewMock { CGSize(width: $0, height: $0) }
    
    lazy var layoutComponent = Row(
        spacing: 8,
        distribution: .start, [
            RowItem.fixed(width: .weight(1), columnWithStartAlignment, Insets(each: 8)),
            RowItem.fixed(width: .weight(1), columnWithEvenlySpacedAlignment, Insets(each: 8)),
            RowItem.fixed(width: .weight(1), columnWithEndAlignment, Insets(each: 8))
        ]
    )
    
    lazy var columnWithStartAlignment = Column(spacing: 8, distribution: .start, [
        .fixed(height: .abs(40), Component(v11)),
        .lessThanOrEqual(30, Component(v12), Insets(each: 8)),
        .lessThanOrEqual(70, Component(v13), Insets(each: 8)),
        ]
    )
    lazy var columnWithEvenlySpacedAlignment = Column(spacing: 8, distribution: .evenlySpaced, [
        .fixed(height: .abs(40), Component(v21)),
        .lessThanOrEqual(30, Component(v22), Insets(each: 8)),
        .lessThanOrEqual(70, Component(v23), Insets(each: 8)),
        ]
    )
    lazy var columnWithEndAlignment = Column(spacing: 8, distribution: .end, [
        .fixed(height: .abs(40), Component(v31)),
        .lessThanOrEqual(30, Component(v32), Insets(each: 8)),
        .lessThanOrEqual(70, Component(v33), Insets(each: 8)),
        ]
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [v11, v21, v31].forEach { v in
            v.backgroundColor = UIColor.red
            addSubview(v)
        }
        [v12, v22, v32].forEach { v in
            v.backgroundColor = UIColor.green
            addSubview(v)
        }
        [v13, v23, v33].forEach { v in
            v.backgroundColor = UIColor.blue
            addSubview(v)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutComponent.performLayout(inFrame: bounds.inset(by: safeAreaInsets))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
