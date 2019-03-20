//
//  HomeViewController.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit
import Reusable
import SwifterSwift

class HomeViewController: ExampleViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController!.navigationBar.logSubView(1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title-\(navigationController?.children.count ?? 0)"
    }
}

extension HomeViewController {
    func setupNavigationItem() {
        // 设置标题，等效 self.title
        navigationItem.title = "title-\(navigationController?.children.count ?? 0)"
        // 设置提示
        navigationItem.prompt = "prompt"
        // 同时显示 leftItems 和 backItem
        navigationItem.leftItemsSupplementBackButton = true
    }

    func addNavigationItem() {
        let backItem = UIBarButtonItem(title: "Left", style: .done, target: self, action: #selector(backAction))
        let shareItem = UIBarButtonItem(image: UIImage(named: "icon_share")!) {
            self.navigationController?.pushViewController(PushToViewController(), animated: true)
        }
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = shareItem
    }

    func showNavigationBar() {
        //过渡效果方案一
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
