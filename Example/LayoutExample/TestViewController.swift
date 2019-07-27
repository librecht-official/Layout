//
//  TestViewController.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 30.06.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit
import Layout


final class TestViewController: UIViewController {
    override func loadView() {
        view = FixedColumTestView()
    }
}

class TestView: UIView {
    let scrollView = UIScrollView()
    
    let v1 = UIView()
    let l1: UILabel = {
        let l1 = UILabel()
        l1.text = "Hello!"
        l1.backgroundColor = UIColor.green
        return l1
    }()
    let v2 = UIView()
    let l2: UILabel = {
        let l2 = UILabel()
        l2.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        l2.numberOfLines = 0
        //        l2.font = UIFont.systemFont(ofSize: 36)
        l2.backgroundColor = UIColor.green
        return l2
    }()
    let l3: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 36)
        label.backgroundColor = UIColor.green
        return label
    }()
    let l4: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 28)
        label.backgroundColor = UIColor.green
        return label
    }()
    
    let column: HeightAwareLayoutComponent
    
    override init(frame: CGRect) {
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(v1)
        v1.addSubview(l1)
        v1.backgroundColor = UIColor.blue
        scrollView.addSubview(v2)
        v2.addSubview(l2)
        v2.backgroundColor = UIColor.white
        scrollView.addSubview(l3)
        scrollView.addSubview(l4)
        
        self.column = HeightAwareColumn(spacing: 8, [
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
            ),
            .automatic(
                HeightAwareComponent(l4, h: .h4(centerX: .abs(40), width: .rel(0.5)), top: 30, bottom: 10)
            )
            ])
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        let h = column.performLayout(inOrigin: .zero, width: bounds.width)
        scrollView.contentSize = CGSize(width: bounds.width, height: h)
    }
}

extension UIScrollView.ContentInsetAdjustmentBehavior: CustomStringConvertible {
    public var description: String {
        switch self {
        case .always: return "always"
        case .automatic: return "automatic"
        case .never: return "never"
        case .scrollableAxes: return "scrollableAxes"
        }
    }
}


class FixedColumTestView: UIView {
    lazy var v1 = UIView(color: UIColor.red)
    lazy var v2 = UIView(color: UIColor.green)
    lazy var v3 = UIView(color: UIColor.blue)
    
    lazy var column = Column(spacing: 8, [
        ColumnItem(
            Component(v1, .zero, .zero),
            length: .abs(64), top: 8, bottom: 16, leading: 16, trailing: 8
        ),
        ColumnItem(
            Component(v2, .zero, .zero),
            length: .weight(1)
        ),
        ColumnItem(
            Component(v3, .zero, .zero),
            length: .weight(2), top: 8, bottom: 16, leading: 16, trailing: 8
        )
        ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(v1)
        addSubview(v2)
        addSubview(v3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        column.performLayout(inFrame: bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}
