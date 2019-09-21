//
//  LessThanRuleView.swift
//  LayoutExample
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Layout

final class LessThanRuleView: UIView {
    lazy var v11 = UIView()
    lazy var v12 = UILabel()
    lazy var v13 = UILabel()
    
    lazy var v21 = UIView()
    lazy var v22 = UILabel()
    lazy var v23 = UILabel()
    
    lazy var v31 = UIView()
    lazy var v32 = UILabel()
    lazy var v33 = UILabel()
    
    lazy var column = Column(
        spacing: 8,
        alignment: .start, [
            ColumnItem.fixed(height: .abs(100), rowWithStartAlignment, Insets(each: 8)),
            ColumnItem.fixed(height: .abs(100), rowWithEvenlySpacedAlignment, Insets(each: 8)),
            ColumnItem.fixed(height: .abs(100), rowWithEndAlignment, Insets(each: 8))
        ]
    )
    
    lazy var rowWithStartAlignment = Row(spacing: 8, alignment: .start, [
        RowItem.fixed(width: .abs(40), Component(v11)),
        RowItem.lessThanOrEqual(30, Component(v12), Insets(each: 8)),
        RowItem.lessThanOrEqual(70, Component(v13), Insets(each: 8)),
        ]
    )
    lazy var rowWithEvenlySpacedAlignment = Row(spacing: 8, alignment: .evenlySpaced, [
        RowItem.fixed(width: .abs(40), Component(v21)),
        RowItem.lessThanOrEqual(30, Component(v22), Insets(each: 8)),
        RowItem.lessThanOrEqual(70, Component(v23), Insets(each: 8)),
        ]
    )
    lazy var rowWithEndAlignment = Row(spacing: 8, alignment: .end, [
        RowItem.fixed(width: .abs(40), Component(v31)),
        RowItem.lessThanOrEqual(30, Component(v32), Insets(each: 8)),
        RowItem.lessThanOrEqual(70, Component(v33), Insets(each: 8)),
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
            v.text = longText
            addSubview(v)
        }
        [v13, v23, v33].forEach { v in
            v.backgroundColor = UIColor.blue
            v.text = longText
            addSubview(v)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        column.performLayout(inFrame: bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

