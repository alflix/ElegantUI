//
//  PushToViewController.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit
import Reusable
import ActionKit

class PushToViewController: ExampleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title-\(navigationController?.children.count ?? 0)"
        navigationAppearance.backgroundAlpha = 0
    }
}

extension PushToViewController {
    // 添加 leftBarButtonItem，rightBarButtonItem
    func addNavigationItem() {
        //let backItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(backAction))
        let backItem = UIBarButtonItem(title: "Left") { self.backAction() }
        let shareItem = UIBarButtonItem(image: UIImage(named: "icon_share")!) { self.otherAction() }
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = shareItem
    }

    // 通过 fixedSpace 修正位置
    func addFixedNavigationItem() {
        //let backItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(backAction))
        let backItem = UIBarButtonItem(title: "Left") { self.backAction() }
        addLeftItem(by: backItem, fix: -5)
    }

    // 通过 fixedSpace 修正位置-1
    func addLeftItem(by item: UIBarButtonItem, fix: CGFloat) {
        let fixItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixItem.width = fix
        navigationItem.leftBarButtonItems = [fixItem, item]
    }

    // 通过 BarButtonItem.customView 修正位置
    func addNavigationItemByCustomView() {
        let backItem = CustomBarButtonItem(image: UIImage(named: "icon_back"), title: nil)
        navigationItem.leftBarButtonItem = backItem
    }

    func hideNavigationBar() {
        //过渡效果方案一
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
