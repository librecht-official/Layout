//
//  TestViewController.swift
//  LayoutDSL
//
//  Created by Vladislav Librecht on 30.06.2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController {
    override func loadView() {
        // Set your view here to see it in simulator/device
        view = RowWithLessThanRuleView()
    }
}
